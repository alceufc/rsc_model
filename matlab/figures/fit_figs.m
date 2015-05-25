function [] = fit_figs( datasetName, varargin )

% fitLineStyles = {'-b'};
% fitData = false;
% heatmapSize = [2.5, 2];
% icdfSize = [4.5, 1.7];

% Parse optional arguments.
parser = inputParser;
addParamValue(parser, 'fitLineStyles', {'-b'}, @iscell);
addParamValue(parser, 'fitData', true, @islogical);
 
parse(parser, varargin{:});
fitLineStyles = parser.Results.fitLineStyles;
fitData = parser.Results.fitData;

switch datasetName
    case 'reddit'
        disp('Loading Reddit data...');
        Tcell = load_reddit_data();
        dMin = 1;
        
        paramGuessCell = {[0.3653, 0.2846, 0.5466, 0.8397, 1.3826, 2.5261, 4.0149, 0.2982]};
        tsModelCell = {@rsc_model};
        diffMinChangeVec = [1e-1];
        minFit = 1e1;
    otherwise
        disp('Not a valid dataset name.');
        return;
end;

disp('Fitting model...');

if fitData 
    paramEstCell = cell(size(tsModelCell));
    for idx = 1:numel(tsModelCell)
        tsModel = tsModelCell{idx};
        paramGuess = paramGuessCell{idx};
        diffMinChange = diffMinChangeVec(idx);
        paramEstCell{idx} = fit_model(Tcell, tsModel, ...
                         'dMin', dMin, ...
                         'paramGuess', paramGuess, ...
                         'minFit', minFit, ...
                         'diffMinChange', diffMinChange);
    end;
else
    paramEstCell = paramGuessCell;
end;

% Print model parameters.
for idx = 1:numel(tsModelCell)
    tsModel = tsModelCell{idx};
    paramEst = paramEstCell{idx};
    [~, paramNames, ~, ~, ~, modelName] = tsModel();
    fprintf('%s Parameters:\n', modelName);
    for paramIdx = 1:numel(paramNames)
        fprintf('\t%s = %.3f\n', paramNames{paramIdx}, paramEst(paramIdx));
    end;
    disp(paramEst);
    fprintf('\n');
end;

% Generate synthetic time-stamps.
TsynthCell = cell(tsModelCell);
for idx = 1:numel(tsModelCell)
    tsModel = tsModelCell{idx};
    fGen = tsModel();
    paramEst = paramEstCell{idx};
    TsynthCell{idx} = fGen(paramEst, numel(cell2mat(Tcell)));
end;

% Get cell-array of model names.
ModelNamesCell = cell(tsModelCell);
for idx = 1:numel(tsModelCell)
    tsModel = tsModelCell{idx};
    [~, ~, ~, ~, ~, modelName] = tsModel();
    ModelNamesCell{idx} = modelName;
end;

settings = load_settings();
histogram_iet_fit_fig(Tcell, ...
                      ModelNamesCell, ...
                      TsynthCell, ...
                      fitLineStyles, ...
                      datasetName, ...
                      settings, ...
                      minFit);

%iet_heatmap_fit_fig(Tcell, ModelNamesCell, TsynthCell, datasetName, settings, 'figSize', heatmapSize);
%iet_oratio_fit_fig(Tcell, ModelNamesCell, TsynthCell, fitLineStyles, datasetName, settings);
%iet_icdf_fit_fig(Tcell, ModelNamesCell, TsynthCell, fitLineStyles, datasetName, settings, 'figSize', icdfSize);

end
