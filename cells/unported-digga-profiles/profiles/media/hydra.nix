{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "hydra.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 5076;
  volumePath = "/volumes/media/hydra";
  downloadPath = "/media/downloads";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      hydra = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "hydra";
      };
    };
    services = {
      hydra = {
        loadBalancer = {
          servers = [
            {
              url = "http://${webAddr}:${toString webPort}";
            }
          ];
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    hydra = {
      autoStart = true;
      image = "linuxserver/nzbhydra2";
      dependsOn = ["sabnzbd"];
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "${volumePath}:/config"
        "${downloadPath}:/downloads"
      ];
      ports = [
        "${webAddr}:${toString webPort}:5076"
      ];
    };
  };
}
