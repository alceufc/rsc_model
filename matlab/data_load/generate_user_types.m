function [ userTypes ] = generate_user_types( userNames, userTypePath )

% Create a hash-table to map a user name to a user type.
fid = fopen(userTypePath);
UserTypeData = textscan(fid, '%[^,], %s%[\r\n]');
fclose(fid);
userNameToType = containers.Map();
for idx = 1:numel(UserTypeData{1})
    userNameToType(UserTypeData{1}{idx}) = UserTypeData{2}{idx};
end;

userTypes = zeros(size(userNames));
for idx = 1:numel(userNames)
    userName = userNames{idx};
    if isKey(userNameToType, userName) && ...
       strcmp(userNameToType(userName), 'bot')
        userTypes(idx) = 1;
    elseif isKey(userNameToType, userName) && ...
         strcmp(userNameToType(userName), 'human')
        userTypes(idx) = 2;
    elseif isKey(userNameToType, userName) && ...
         strcmp(userNameToType(userName), 'chat')
        userTypes(idx) = 3;
    elseif isKey(userNameToType, userName) && ...
        strcmp(userNameToType(userName), 'rate_limit')
        userTypes(idx) = 3;
    elseif isKey(userNameToType, userName) && ...
        strcmp(userNameToType(userName), 'corporate')
        userTypes(idx) = 4;
    end;
end;

end