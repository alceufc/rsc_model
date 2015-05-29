addpath(genpath('.')); % Add sub-folders to Matlab path.
[fGen, ~, paramGuess] = rsc_model();
Tsynth = fGen(paramGuess, 1e5);

settings = load_settings();
figure; 
figName = 'synth_log_bin_hist.png';
plot_path  = fullfile(settings.doc_dir, figName);

plot_iat_hist(Tsynth);

save_as_png(plot_path, [5, 2]);

Tcell = load_reddit_data();
paramEst = fit_model(Tcell, @rsc_model, 'paramGuess', paramGuess);

timeStampTotal = numel(cell2mat(Tcell));
Tsynth = fGen(paramEst, timeStampTotal);

figure; 
figName = 'synth_log_bin_hist_fit.png';
plot_path  = fullfile(settings.doc_dir, figName);

plot_iat_hist_fit(Tcell, Tsynth);

save_as_png(plot_path, [5, 2]);