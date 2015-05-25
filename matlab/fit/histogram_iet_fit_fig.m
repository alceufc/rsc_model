function [] = histogram_iet_fit_fig( Tcell, ...
                                     ModelNamesCell, ...
                                     TsynthCell, ...
                                     fitLineStyles, ...
                                     datasetName, ...
                                     settings, ...
                                     minFit, ...
                                     varargin )

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'figSize', [6, 3], @isnumeric);

parse(parser, varargin{:});
figSize = parser.Results.figSize;

for idx = 1:numel(TsynthCell)
    figure;
    modelName = ModelNamesCell{idx};
    
    figName = sprintf('%s_log_bin_histogram_iat_fit_%s.eps', datasetName, modelName);
    plot_path  = fullfile(settings.fig_dir, figName);

    legendEntries = {'Data', ModelNamesCell{idx}};
    plot_iat_hist_fit(Tcell, TsynthCell(idx), 'dMin', minFit, 'fitLineStyle', fitLineStyles{idx});

    legend(legendEntries);
    save_as_eps(plot_path, figSize);
end;

end