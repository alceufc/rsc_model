function [ fnames, allUserNames ] = list_timestamp_files( timestampsDir, delimiter )
% LIST_TIMESTAMP_FILES List file names containing users' time-stamp data.
%
%   delimiter: string that separates the user name from remaining part of
%   the file name.

dataFiles = dir(timestampsDir);
fnames = cell(numel(dataFiles), 1);
for i = 1:numel(dataFiles)
    fileName = dataFiles(i).name;
    fnames{i} = fileName;
end

% Get a list of user names.
allUserNames = cell(size(fnames));
for idx = 1:numel(allUserNames)
    fileName = fnames{idx};
    fileNameTokens = textscan(fileName, '%s', 'delimiter', delimiter);
    fileNameTokens = fileNameTokens{1};
    allUserNames{idx} = strjoin(fileNameTokens(1:end-1)', delimiter);
end;

end