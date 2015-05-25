function [ settings ] = load_settings(  )

SETTINGS_FILE = '../settings.json';

json_str = fileread(SETTINGS_FILE);
settings = parse_json(json_str);
settings = settings{1};

end

