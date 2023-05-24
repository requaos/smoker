{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";
  };
}
