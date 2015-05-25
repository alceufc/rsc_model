function [ fGen, paramNames, paramGuess, paramMin, paramMax, modelName ] = rsc_model( )

paramGuess = [0.3, 0.7, ...
              1, ...
              0.7, 0.9, ...
              log10(40), ...
              log10(600), ...
              8/24];

paramMin = [0, 0, ...
            0, ...
            0.2, 0.2, ...
            log10(1), ...
            log10(100), ...
            0];
        
paramMax = [1.0, 1.0, ...
            1.0, ...
            10.0, 10.0, ...
            log10(3600), ...
            log10(3600 * 24 * 30), ...
            12/24];

paramNames = {'pRest', 'pActive', ...
              'pPost', ...
              'sigmaRest', 'sigmaActive'...
              'periodActive', ...
              'periodRest', ...
              'totalSleep'};
          
fGen = @generateTs;

modelName = 'RSC';

function [ T ] = generateTs(params, tSize)
    pProb = params(1);
    qProb = params(2);
    pPost = params(3);
    sigmaRest = params(4);
    sigmaActive = params(5);
    lambdaActive = 1/(10^params(6));
    lambdaRest = 1/(10^params(7));
    totalSleep = params(8);
    
    dayStart = 0;
    dayEnd = 24 * 3600 * (1 - totalSleep);

    % Initialize state machine.
    states = struct;
    states.NONE = 0;
    states.ACTIVE = 1;
    states.REST = 2;
    states.SLEEP = 3;
    previousState = states.NONE;
    currentState = states.ACTIVE;
    
    % Start conditions.
    previousActiveDelay = 1/lambdaActive;
    previousRestDelay = 1/lambdaRest;
    
    
    randNumbers = rand(1, ceil(tSize/2));
    randNumbersIdx = 1;
    
    T = zeros(tSize, 1);
    mu = previousActiveDelay + 1/(lambdaActive*exp(1));
    rate = 1/mu;
    delay = -log(randNumbers(randNumbersIdx))./rate;
    
    randNumbersIdx = randNumbersIdx + 1;
    previousActiveDelay = delay;
    T(1) = dayStart + delay;
    
    delay = 0;
    tCount = 2;
    while tCount <= numel(T)
        switch currentState
            case states.ACTIVE
                % Generate delay.
                %mu = previousActiveDelay + 1/(lambdaActive*exp(1));
                mu = sigmaActive*previousActiveDelay + 1/(lambdaActive*exp(1));
                rate = 1/mu;
                activeDelay = -log(randNumbers(randNumbersIdx))./rate;
                %activeDelay = activeDelay * (sigmaActive);
                
                if randNumbersIdx < numel(randNumbers)
                    randNumbersIdx = randNumbersIdx + 1;
                else
                    % Re-use randomly generated numbers.
                    randNumbersIdx = 1;
                end;
                
                previousActiveDelay = activeDelay;
                delay = delay + activeDelay;
                
                if rand < pPost
                    T(tCount) = T(tCount - 1) + delay;
                    tCount = tCount + 1;
                    delay = 0;
                end;
                
                % Transition to the next state.
                currentTime = T(tCount - 1) + delay;
                if isSleeping(currentTime, dayStart, dayEnd)            
                   currentState = states.SLEEP;
                elseif rand < pProb
                    currentState = states.REST;
                    %previousRestDelay = 1/lambdaRest;
                    previousRestDelay = 0;
                else
                    currentState = states.ACTIVE;
                end;
                previousState = states.ACTIVE;
                
            case states.REST
                % Generate delay.
                %mu = previousRestDelay + 1/(lambdaRest*exp(1));
                mu = sigmaRest*previousRestDelay + 1/(lambdaRest*exp(1));    
                rate = 1/mu;
                restDelay = -log(randNumbers(randNumbersIdx))./rate;
                %restDelay = restDelay * (sigmaRest);
                
                if randNumbersIdx < numel(randNumbers)
                    randNumbersIdx = randNumbersIdx + 1;
                else
                    % Re-use randomly generated numbers.
                    randNumbersIdx = 1;
                end;
                previousRestDelay = restDelay;
                delay = delay + restDelay;
                
                % Transition to the next state.
                currentTime = T(tCount - 1) + delay;
                if isSleeping(currentTime, dayStart, dayEnd)
                    currentState = states.SLEEP;
                elseif rand < qProb
                    currentState = states.ACTIVE;
                    %previousActiveDelay = 1/lambdaActive;
                    previousActiveDelay = 0;
                else
                    currentState = states.REST;
                end;
                previousState = states.REST;     

            case states.SLEEP
                currentTime = T(tCount - 1) + delay;
                sleepDelay = timeUntilWakeUp(currentTime, dayStart, dayEnd);
                delay = delay + sleepDelay;
                
                % Transition to the next state.
                %currentState = ceil(rand * 2);
                currentState = states.REST;
                %previousRestDelay = sleepDelay;
        end;
    end;
end

function [ sleeping ] = isSleeping(currentTime, dayStart, dayEnd )
    % Get the current second of the day.
    secondOfDay = mod(currentTime, 24 * 3600);
    if secondOfDay > dayStart && secondOfDay < dayEnd
        sleeping = false;
    else
        sleeping = true;
    end;
end

function [ totalTime ] = timeUntilWakeUp( currentTime, dayStart, dayEnd )
    % Get the current second of the day.
    dayLength = 24 * 3600;
    secondOfDay = currentTime - dayLength * floor(currentTime/dayLength);
    
    if secondOfDay < dayStart
        totalTime = dayStart - secondOfDay;
    elseif secondOfDay >= dayEnd
        totalTime = dayStart + (24 * 3600 - secondOfDay);
    else
        totalTime = dayStart + (24 * 3600 - secondOfDay);
        warning('Computing timeUntilWakeUp while not in sleep state.');
    end;
end

end