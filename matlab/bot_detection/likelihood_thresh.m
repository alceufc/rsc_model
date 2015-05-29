function [ Lthresh ] = likelihood_thresh(Ltrain, ...
                                         userTypeTrain, ...
                                         FpCost, FnCost)

% LIKELIHOOD_THRESH Estimates a classification threshold for the bot 
%   likelihood values.
%
%   [ Lthresh ] = LIKELIHOOD_THRESH( Ltrain, userTypeTrain, ...
%   FpCost, FnCost ) finds the classification threshold Lthresh that 
%   minimizes the F-Beta-Measure, where the Beta is computed using 
%   the parameters FpCost and FnCost. 

minErrorCost = +inf;
Lthresh = 0.5;

uniqueScores = Ltrain(userTypeTrain == 1);
for pos = 1:numel(uniqueScores)
    userTypeTrainThresh = uniqueScores(pos);
    PreduserTypeTrain = zeros(size(userTypeTrain));
    PreduserTypeTrain(Ltrain > userTypeTrainThresh) = 1;
    
    FP = sum(userTypeTrain == 0 & PreduserTypeTrain == 1);
    FN = sum(userTypeTrain == 1 & PreduserTypeTrain == 0);
    TP = sum(userTypeTrain == 1 & PreduserTypeTrain == 1);
    
    if (TP + FP) > 0
        Prec = TP/(TP + FP); 
    else
        Prec = 0; 
    end;
    Sens = TP/(TP + FN); 
    
    if (Prec + Sens) > 0
        Fmeas = Prec * Sens / (FnCost*Prec + FpCost*Sens);
    else
        Fmeas = 0;
    end;
    errorCost = 1 - Fmeas;
    if errorCost < minErrorCost
        minErrorCost = errorCost;
        Lthresh = userTypeTrainThresh;
    end;
end;

end