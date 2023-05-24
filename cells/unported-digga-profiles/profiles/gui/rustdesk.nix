{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      rustdesk
    ];
  };
}
