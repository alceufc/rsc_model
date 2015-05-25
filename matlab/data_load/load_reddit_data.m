function [ Tcell, Ucell, Dcell, Lcell, userNames, userTypes] = load_reddit_data( varargin )
% LOAD_REDDIT_DATA Loads Reddit comments dataset.
%
%  LOAD_REDDIT_DATA(Name, Value) specifies the following options using
%  name-value pairs:
%
%    - maxUsers: Loads data for at most maxUsers. If maxUsers = 0 (default) 
%    then LOAD_REDDIT_DATA loads data for all users.
%
%    - minComments: Discards users with less than minComments comments
%    (default is 800).
%
%    - shuffleUsers: Shuffle user list (default is false).

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'maxUsers', 0, @isnumeric);
addOptional(parser, 'minComments', 800, @isnumeric);
addOptional(parser, 'shuffleUsers', false, @islogical);

parse(parser, varargin{:});
maxUsers = parser.Results.maxUsers;
minComments = parser.Results.minComments;
shuffleUsers = parser.Results.shuffleUsers;

settings = load_settings();
fprintf('Loading dataset located at:\n\t%s\n', ...
        settings.reddit_dataset_dir);

timestampsDir = fullfile(settings.reddit_dataset_dir, '/timestamps/*.csv');
[fnames, allUserNames] = list_timestamp_files(timestampsDir, '_');

userTypePath = settings.user_type.reddit;
userIdxs = sort_users(allUserNames, shuffleUsers, userTypePath);

totalUsers = numel(fnames);
if maxUsers < 1 || maxUsers > totalUsers
    maxUsers = totalUsers;
end;

% Pre-allocate space.
Tcell = cell(maxUsers, 1);
Ucell = cell(maxUsers, 1);
Dcell = cell(maxUsers, 1);
Lcell = cell(maxUsers, 1);
userNames = cell(numel(userIdxs), 1);

addedUsers = 0;
for pos = 1:totalUsers
    fileName = fnames{userIdxs(pos)};
    timeline_data_path = fullfile(settings.reddit_dataset_dir, ...
                         sprintf('/timestamps/%s', fileName));
    fid = fopen(timeline_data_path);
    F_data = fscanf(fid, '%d, %d, %d, %d', [4, inf]);
    fclose(fid);
    F_data = F_data';

    if size(F_data, 1) < minComments
        continue;
    end;

    addedUsers = addedUsers + 1;
    [Tcell{addedUsers}, IX] = sort(F_data(:, 1));
    Ucell{addedUsers} = F_data(IX, 2);
    Dcell{addedUsers} = F_data(IX, 3);
    Lcell{addedUsers} = F_data(IX, 4);
    userNames{addedUsers} = allUserNames{userIdxs(pos)};

    if addedUsers == maxUsers % Stop adding users.
        break;
    end;
end;

% Resize the arrays if userIdx is less than nUsers.
Tcell = Tcell(1:addedUsers);
Ucell = Ucell(1:addedUsers);
Dcell = Dcell(1:addedUsers);
Lcell = Lcell(1:addedUsers);
userNames = userNames(1:addedUsers);

% Sort the users based on the user name.
[userNames, IX] = sortrows(userNames);
Tcell = Tcell(IX);
Ucell = Ucell(IX);
Dcell = Dcell(IX);
Lcell = Lcell(IX);

userTypes = generate_user_types(userNames, userTypePath);

end
