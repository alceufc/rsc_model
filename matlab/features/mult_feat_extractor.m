function [ featureVector ] = mult_feat_extractor(tsSeq, extractors)

Vecs = cell(1, numel(extractors));
for idx = 1:numel(extractors)
    extFunc = extractors{idx};
    Vecs{idx} = extFunc(tsSeq);
end;
featureVector = cell2mat(Vecs);

end