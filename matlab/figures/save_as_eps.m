function [] = save_as_eps( plot_path, figSize )
% SAVE_AS_ESP Saves current figure handle (gfc) as an ESP.

settings = load_settings();
warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(settings.fig_dir);
warning('on', 'MATLAB:MKDIR:DirectoryExists');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 figSize(1) figSize(2)]);
print(gcf, '-depsc2', plot_path);

end