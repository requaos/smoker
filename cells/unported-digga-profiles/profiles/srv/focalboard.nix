{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "focalboard.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 8165;
  volumePath = "/volumes/focalboard";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      focalboard = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "focalboard";
      };
    };
    services = {
      focalboard = {
        loadBalancer = {
          servers = [
            {
              url = "http://${addr}:${toString port}";
            }
          ];
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    focalboard = {
      autoStart = true;
      image = "mattermost/focalboard";
      volumes = [
        "${volumePath}:/opt/focalboard/data"
      ];
      ports = [
        "${addr}:${toString port}:8000"
      ];
    };
  };
}
