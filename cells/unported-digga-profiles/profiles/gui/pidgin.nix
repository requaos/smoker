{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      (pidgin.override {
        plugins = with pkgs; [
          pidgin-opensteamworks
          pidgin-window-merge
          purple-discord
          purple-matrix
          purple-signald
          # pidgin-indicator
          # pidgin-latex
          # pidgin-xmpp-receipts
          # purple-slack
        ];
      })
    ];
  };
}
