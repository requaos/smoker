{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "sabnzbd.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 5077;
  volumePath = "/volumes/media/sabnzbd";
  mediaPath = "/media";
  downloadPath = "${mediaPath}/downloads";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      sabnzbd = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "sabnzbd";
      };
    };
    services = {
      sabnzbd = {
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
    sabnzbd = {
      autoStart = true;
      image = "linuxserver/sabnzbd";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "${volumePath}/config:/config"
        "${volumePath}/incomplete-downloads:/incomplete-downloads"
        "${downloadPath}:/downloads"
      ];
      ports = [
        "${webAddr}:${toString webPort}:8080"
      ];
    };
  };
}
