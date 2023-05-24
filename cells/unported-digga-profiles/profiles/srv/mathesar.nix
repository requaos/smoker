{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "mathesar.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 8166;
  volumePath = "/volumes/mathesar";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      mathesar = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "mathesar";
      };
    };
    services = {
      mathesar = {
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
    mathesar = {
      autoStart = true;
      image = "mattermost/mathesar";
      volumes = [
        "${volumePath}:/opt/mathesar/data"
      ];
      ports = [
        "${addr}:${toString port}:8000"
      ];
    };
  };
}
