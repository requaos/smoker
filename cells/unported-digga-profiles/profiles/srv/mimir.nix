{
  config,
  lib,
  pkgs,
  ...
}: let
  # volumePath = "/volumes/mimir";
in {
  services.mimir = {
    enable = true;
    configuration = {};
  };
}
