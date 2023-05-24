{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "sonarr.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 8989;
  volumePath = "/volumes/media/sonarr";
  mediaPath = "/media";
  downloadPath = "${mediaPath}/downloads/shows";
  showsPath = "${mediaPath}/shows";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      sonarr = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "sonarr";
      };
    };
    services = {
      sonarr = {
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
    sonarr = {
      autoStart = true;
      image = "linuxserver/sonarr";
      dependsOn = ["hydra" "sabnzbd"];
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "${volumePath}/config:/config"
        "${downloadPath}:/downloads/shows"
        "${showsPath}:/tv"
      ];
      ports = [
        "${webAddr}:${toString webPort}:8989"
      ];
    };
  };
}
