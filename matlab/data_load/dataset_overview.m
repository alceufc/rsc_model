function []  = dataset_overview( Tcell, userTypes )

Tlen = cellfun(@numel, Tcell);

fprintf('\tTotal number of users: %d.\n', numel(userTypes));
fprintf('\tTotal number of time-stamps: %d.\n', sum(Tlen));
fprintf('\tNumber of humans: %d.\n', sum(userTypes == 0 | userTypes == 2));
fprintf('\tNumber of bots: %d.\n', sum(userTypes == 1));
fprintf('\tMinimum number of time-stamps: %d.\n', min(Tlen));
fprintf('\tMaximum number of time-stamps: %d.\n', max(Tlen));
fprintf('\tMedian number of time-stamps: %d.\n', median(Tlen));

end