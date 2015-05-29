function [ Features ] = extract_features( Tcell, varargin )
% EXTRACT_FEATURES Extract temporal features from data.

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'extractors', {@extract_iat_hist});

parse(parser, varargin{:});
extractors = parser.Results.extractors;

featureVector = mult_feat_extractor(Tcell{1}, extractors);
Features = zeros(numel(Tcell), numel(featureVector));
Features(1,:) = featureVector;
for idx = 2:numel(Tcell)
    Features(idx,:) = mult_feat_extractor(Tcell{idx}, extractors);
end;
end