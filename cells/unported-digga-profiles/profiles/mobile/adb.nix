{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  users.users.${config.vars.username} = {
    extraGroups = ["adbusers"];
  };

  # home-manager.users.${config.vars.username} = {
  #   home.packages = with pkgs; [
  #     adb
  #   ];
  # };
}
