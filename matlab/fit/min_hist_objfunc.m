function [ objFuncVals ] = min_hist_objfunc( params, ...
                                             dataCounts, ...
                                             bucketCenters, ...
                                             bucketLims, ...
                                             fGen, ...
                                             tSize, ...
                                             minFit )

% MIN_HIST_OBJFUNC Error between data and synthetic histogram.

Tsynth = fGen(params, tSize);
Dsynth = activity_delays(Tsynth);
synthCounts = log_bin_hist(Dsynth, {bucketCenters, bucketLims});

synthCounts = synthCounts(bucketCenters > minFit);
synthCounts = synthCounts ./ sum(synthCounts);

objFuncVals = dataCounts - synthCounts;
disp(params);

end