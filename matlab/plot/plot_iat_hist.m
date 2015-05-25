function [ centersAndBuckets, hCurve ] = plot_iat_hist( Tcell, varargin )
% PLOT_IAT_HIST Log-binned histogram of inter-arrival times.

% Parse optional arguments.
parser = inputParser;
addParamValue(parser, 'dMin', 1, @isnumeric);
addParamValue(parser, 'dMax', 1e7, @isnumeric);
addParamValue(parser, 'nBins', 300, @isnumeric);
addParamValue(parser, 'xScaleLog', true, @islogical);
addParamValue(parser, 'yScaleLog', false, @islogical);
addParamValue(parser, 'axesHandle', -1, @isnumeric);
addParamValue(parser, 'centersAndBuckets', {}, @iscell);
addParamValue(parser, 'lineStyle', '-b', @isstr);

parse(parser, varargin{:});
dMin = parser.Results.dMin;
dMax = parser.Results.dMax;
nBins = parser.Results.nBins;
xScaleLog = parser.Results.xScaleLog;
yScaleLog = parser.Results.yScaleLog;
axesHandle = parser.Results.axesHandle;
centersAndBuckets = parser.Results.centersAndBuckets;
lineStyle = parser.Results.lineStyle;

% Get the delays from the users' time-stamps. 
D = activity_delays(Tcell);

% Discard delays outside the interval [dMin, dMax].
M = D >= dMin & D <= dMax;
D = D(M);

% Plot.
if numel(centersAndBuckets) > 0
    centers = centersAndBuckets{1};
    bucketLims = centersAndBuckets{2};
    [counts, centers, ~, hCurve] = spline_hist(D, {centers, bucketLims}, ...
                           'logBins', true, ...
                           'lineStyle', lineStyle, ...
                           'axesHandle', axesHandle, ...
                           'discardTails', true);
else
    [counts, centers, bucketLims, hCurve] = spline_hist(D, nBins, ...
                                   'logBins', true, ...
                                   'lineStyle', lineStyle, ...
                                   'axesHandle', axesHandle);
   centersAndBuckets = {centers, bucketLims};
end;

hold on;

if xScaleLog == true
    set(gca, 'xScale', 'log');
end;
if yScaleLog == true
    set(gca, 'yScale', 'log');
    set(gca, 'xlim', [min(centers)/2, max(centers)*2]);
    set(gca, 'ylim', [min(counts(counts > 0))/2, max(counts)*2]);
end;

xlabel('\Delta, IAT (seconds)');
ylabel('PDF');

end