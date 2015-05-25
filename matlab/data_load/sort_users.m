function [ userIdxs ] = sort_users( AllUsers, shuffleUsers, userTypePath )
% SORT_USER Returns an array of user indexes prioritizing labeled users.
settings = load_settings();

% Create a cell-array of labeled user names.
fid = fopen(userTypePath);
UserTypeData = textscan(fid, '%[^,], %s\n');
fclose(fid);
numberOfLabeledUsers = numel(UserTypeData{1});
LabeledUsers = cell(1, numberOfLabeledUsers);
for idx = 1:numberOfLabeledUsers
    LabeledUsers{idx} = UserTypeData{1}{idx};
end;

[~, labeledIdxs] = intersect(AllUsers, LabeledUsers);
unlabeledIdxs = setdiff(1:numel(AllUsers), labeledIdxs)';
if ~shuffleUsers
    rng('default'); % Always use the same set of users.
end;

unlabeledIdxs = unlabeledIdxs(randperm(numel(unlabeledIdxs)));
labeledIdxs = labeledIdxs(randperm(numel(labeledIdxs)));
userIdxs = [labeledIdxs; unlabeledIdxs];

if ~shuffleUsers
    rng('shuffle');
end;

end