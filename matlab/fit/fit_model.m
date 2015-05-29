function [ paramEst, rss, res ] = fit_model( Tcell, tsModel, varargin )
% FIT_MODEL Fits model to time-stamp data.
%  

% Parse optional arguments.
parser = inputParser;
addParamValue(parser, 'dMin', 1, @isnumeric);
addParamValue(parser, 'dMax', inf, @isnumeric);
addParamValue(parser, 'tSize', 1e5, @isnumeric);
addParamValue(parser, 'nBins', 100, @isnumeric);
addParamValue(parser, 'paramGuess', [], @isnumeric);
addParamValue(parser, 'diffMinChange', 1e-1, @isnumeric);
addParamValue(parser, 'minFit', 10, @isnumeric);
addParamValue(parser, 'MaxFunEvals', 100, @isnumeric);
addParamValue(parser, 'MaxIter', 100, @isnumeric);
 
parse(parser, varargin{:});
dMin = parser.Results.dMin;
dMax = parser.Results.dMax;
tSize = parser.Results.tSize;
nBins = parser.Results.nBins;
paramGuess = parser.Results.paramGuess;
diffMinChange = parser.Results.diffMinChange;
minFit = parser.Results.minFit;
MaxFunEvals = parser.Results.MaxFunEvals;
MaxIter = parser.Results.MaxIter;

% Discard IATs outside the range dMin and dMax.
Ddata = activity_delays(Tcell);
M = Ddata >= dMin & Ddata <= dMax;
Ddata = Ddata(M);

% Compute a log-binned histogram from the time-stamp data.
[dataCounts, bucketCenters, bucketLims] = log_bin_hist(Ddata, nBins);
dataCounts = dataCounts(bucketCenters > minFit);
dataCounts = dataCounts ./ sum(dataCounts);

% Generate synthetic data.
[fGen, ~, defaultParams, paramMin, paramMax]  = tsModel();
if numel(paramGuess) == 0
    paramGuess = defaultParams;
end;

objFunc = @(params, bucketIdxs) min_hist_objfunc(params, ...
                                                 dataCounts, ...
                                                 bucketCenters, ...
                                                 bucketLims, ...
                                                 fGen, ...
                                                 tSize, minFit);

                                             
% Find the parameters
options = optimset('Algorithm', 'trust-region-reflective',...
                   'MaxFunEvals', MaxFunEvals, ...
                   'MaxIter', MaxIter,...
                   'Display', 'off', ...
                   'DiffMinChange', diffMinChange);

disp('Fitting model...');
[paramEst, rss, res] = lsqnonlin(objFunc, ...
                                 paramGuess, ...
                                 paramMin, ...
                                 paramMax, ...
                                 options);

end
