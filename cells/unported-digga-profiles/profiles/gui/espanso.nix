{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    services.espanso = {
      enable = true;
      settings = {
        toggle_key = "META";
        matches = [
          {
            trigger = ":shrug";
            replace = ''¯\_(ツ)_/¯'';
          }
          {
            trigger = ":date";
            replace = ''{{output}}'';
            vars = [
              {
                name = "output";
                type = "date";
                params = {
                  format = "%Y-%m-%d";
                };
              }
            ];
          }
          {
            trigger = ":now";
            replace = ''{{output}}'';
            vars = [
              {
                name = "output";
                type = "date";
                params = {
                  format = "%Y-%m-%dT%H-%M-%S";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
