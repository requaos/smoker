{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "radarr.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 7878;
  volumePath = "/volumes/media/radarr";
  mediaPath = "/media";
  downloadPath = "${mediaPath}/downloads/movies";
  moviesPath = "${mediaPath}/movies";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      radarr = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "radarr";
      };
    };
    services = {
      radarr = {
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
    radarr = {
      autoStart = true;
      image = "linuxserver/radarr";
      dependsOn = ["hydra" "sabnzbd"];
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "${volumePath}/config:/config"
        "${downloadPath}:/downloads/movies"
        "${moviesPath}:/movies"
      ];
      ports = [
        "${webAddr}:${toString webPort}:7878"
      ];
    };
  };
}
