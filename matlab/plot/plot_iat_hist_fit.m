function [] = plot_iat_hist_fit(Tdata, Tsynth, varargin)
% DELAY_LOG_BIN_HIST Plots log-binned histogram of IAT for real and 
% synthetic data.

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'dMin', 1, @isnumeric);
addOptional(parser, 'dMax', inf, @isnumeric);
addOptional(parser, 'nBins', 300, @isnumeric);
addParamValue(parser, 'fitLineStyle', '-b', @isstr);

parse(parser, varargin{:});
dMin = parser.Results.dMin;
dMax = parser.Results.dMax;
nBins = parser.Results.nBins;
fitLineStyle = parser.Results.fitLineStyle;

[centersAndBuckets, hDataCurve] = plot_iat_hist(Tdata, ...
                            'nBins', nBins, ...
                            'dMin', dMin, ...
                            'dMax', dMax);

dataColor = [0.5, 0.5, 0.5];                        
set(hDataCurve, 'LineStyle', 'none');
set(hDataCurve, 'Marker', 'o');
set(hDataCurve, 'MarkerEdgeColor', 'none');
set(hDataCurve, 'MarkerSize', 3);
set(hDataCurve, 'MarkerFaceColor', dataColor);
                        
hold on;
plot_iat_hist(Tsynth, ...
              'lineStyle', fitLineStyle, ...
              'centersAndBuckets', centersAndBuckets, ...
              'dMax', dMax);

hold off;
legend('Data', 'Model');

end