function [ Features ] = extract_rsc_features( Tcell, paramEst, varargin )

parser = inputParser;
addParamValue(parser, 'dMin', 1, @isnumeric);
addParamValue(parser, 'dMax', 1e6, @isnumeric);
addOptional(parser, 'nBins', 30, @isnumeric);

parse(parser, varargin{:});
dMin = parser.Results.dMin;
dMax = parser.Results.dMax;
nBins = parser.Results.nBins;

fGen = rsc_model();
featureVector = extract_model_dist(Tcell{1}, paramEst);
Features = zeros(numel(Tcell), numel(featureVector));
Features(1,:) = featureVector;
for idx = 2:numel(Tcell)
    Features(idx,:) = extract_model_dist(Tcell{idx}, paramEst);
end;

end