function [ Ltest, Ltrain ] = estimate_bot_likelihood( TcellTest, ...
                                                      TcellTrain, ...
                                                      userTypeTrain, ...
                                                      varargin )
% ESTIMATE_BOT_LIKELIHOOD Estimates likelihood of a user beign a bot.
%
%     ESTIMATE_BOT_LIKELIHOOD returns a vector L of the same size as 
%     TcellTest where each entry L(idx) corresponds to the likelihood 
%     (i.e. the score) that the time-stamp sequence TcellTest(idx) is 
%     from a bot.
%
%     TcellTrain and userTypeTrain are used as training data.

% Parse optional arguments.
parser = inputParser;
%addParamValue(parser, 'extractors', {@extract_model_dist}, @iscell);
%addParamValue(parser, 'extractors', {@extract_iat_hist}, @iscell);

%parse(parser, varargin{:});
%extractors = parser.Results.extractors;

[~, ~, paramGuess] = rsc_model();
paramEst = fit_model(TcellTrain, @rsc_model, 'paramGuess', paramGuess);
% paramEst = fit_model(TcellTrain, @rsc_model, 'paramGuess', paramGuess, ...
%                      'MaxFunEvals', 10, 'MaxIter', 10);

FeaturesTrain = extract_rsc_features(TcellTrain, paramEst);
FeaturesTest = extract_rsc_features(TcellTest, paramEst);

nb = NaiveBayes.fit(FeaturesTrain, userTypeTrain);

Ltrain = posterior(nb, FeaturesTrain);
Ltrain = Ltrain(:,2);

Ltest = posterior(nb, FeaturesTest);
Ltest = Ltest(:,2);
end