{
  config,
  lib,
  pkgs,
  ...
}: let
  volumePath = "/volumes/victoriametrics";
  addr = "127.0.0.1";
  port = "8428";
in {
  services.victoriametrics = {
    enable = true;
    listenAddress = "${addr}:${port}";
    # retentionPeriod = 1; # months
    extraOptions = [];

    # vmagent = {
    #   remoteWriteUrl = "";
    # };
  };
}
