{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.signald = {
    enable = true;
    user = "${config.vars.username}";
    group = "users";
    socketPath = "/run/signald/signald.sock";
  };

  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      signaldctl
    ];
  };
}
