function [ featureVector ] = extract_iat_hist( tSeq, varargin )

parser = inputParser;
addParamValue(parser, 'dMin', 1, @isnumeric);
addParamValue(parser, 'dMax', 1e6, @isnumeric);
addParamValue(parser, 'nBins', 30, @isnumeric);

parse(parser, varargin{:});
dMin = parser.Results.dMin;
dMax = parser.Results.dMax;
nBins = parser.Results.nBins;

D = activity_delays(tSeq);

minExp = log10(dMin);
maxExp = log10(dMax);
bucketLims = logspace(minExp, maxExp, nBins + 1);
centers = bucketLims(1:end-1) + (bucketLims(2:end) - bucketLims(1:end-1))/2;
counts = log_bin_hist(D, {centers, bucketLims});
featureVector = counts ./ sum(counts);

end