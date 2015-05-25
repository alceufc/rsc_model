function [counts, centers, bucketLims, hCurve] = spline_hist( X, varargin )

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'inputParam', 10);
addParamValue(parser, 'logBins', false, @islogical);
addParamValue(parser, 'lineStyle', '-b', @isstr);
addParamValue(parser, 'discardTails', false, @islogical);
addParamValue(parser, 'axesHandle', -1, @isnumeric);

parse(parser, varargin{:});
inputParam = parser.Results.inputParam;
logBins = parser.Results.logBins;
lineStyle = parser.Results.lineStyle;
discardTails = parser.Results.discardTails;
axesHandle = parser.Results.axesHandle;

% Get the counts and centeres of the histogram.
if numel(inputParam) > 1
    centers = inputParam{1};
    bucketLims = inputParam{2};
    if logBins
        counts = log_bin_hist(X, {centers, bucketLims});
    else
        counts = hist(X, centers);
    end;
else
    nBins = inputParam;
    if logBins
        [counts, centers, bucketLims] = log_bin_hist(X, nBins);
    else
        [counts, centers] = hist(X, nBins);
        bucketLims = [0, centers];
    end;
end;

% Normalize the bin counts.
% Since trapz does not work with log-spaced bins, we use an approximation.
counts = counts ./ sum(counts); 

if discardTails
    counts = counts(2:end-1);
    centers = centers(2:end-1);
end;

countsSpline = spline(centers, counts, centers);
if axesHandle == -1
    hCurve = plot(centers, countsSpline, lineStyle);
else
    hCurve = plot(axesHandle, centers, countsSpline, lineStyle);
end;
set(hCurve, 'LineWidth', 1.2);

box on;
xlabel('X');
ylabel('Fraction');

set(gca, 'xlim', [min(centers), max(centers)]);
yLim = get(gca, 'ylim');
set(gca, 'ylim', [0, yLim(2)]);

end