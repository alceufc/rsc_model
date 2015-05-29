function [ modelDist ] = extract_model_dist( tSeq, paramEst, varargin )

parser = inputParser;
addOptional(parser, 'nBins', 30, @isnumeric);

parse(parser, varargin{:});
nBins = parser.Results.nBins;

fGen = rsc_model();
Tsynth = fGen(paramEst, numel(tSeq));

Dsynth = activity_delays(Tsynth);
[synthCounts, bucketCenters, bucketLims] = log_bin_hist(Dsynth, nBins );

Ddata = activity_delays(tSeq);
dataCounts = log_bin_hist(Ddata, {bucketCenters, bucketLims});

synthCounts = synthCounts ./ sum(synthCounts);
dataCounts = dataCounts ./ sum(dataCounts);

modelDist = sum(abs(dataCounts - synthCounts));

end