function [ counts, centers, bucketLims ] = log_bin_hist( X, inputParam )
% LOG_BIN_HIST Log-binned histogram.
%
% Obs.: Only use for positive values.

if numel(inputParam) > 1
    centers = inputParam{1};
    bucketLims = inputParam{2};
else
    nBins = inputParam;
    minExp = log10(min(X(X > 0)));
    maxExp = log10(max(X));
    bucketLims = logspace(minExp, maxExp, nBins + 1);
    bucketLims = unique(ceil(bucketLims));
    centers = bucketLims(1:end-1) + (bucketLims(2:end) - ...
              bucketLims(1:end-1))/2;
end;

counts = ones(size(centers));
for idx = 1:numel(X)
    if X(idx) < bucketLims(1);
        continue;
    end;

    % Find the correct bucket.
    foundBucket = false;
    for bucket = 1:numel(centers)
        bucketUpperLim = bucketLims(bucket + 1);
        if X(idx) < bucketUpperLim 
            foundBucket = true;
            break;
        end;
    end;
    if foundBucket
        counts(bucket) = counts(bucket) + 1;
    end;
end;
end

