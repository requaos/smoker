{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "jellyfin.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 8096;
  volumePath = "/volumes/media/jellyfin";
  mediaPath = "/media";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      jellyfin = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "jellyfin";
      };
    };
    services = {
      jellyfin = {
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
    jellyfin = {
      autoStart = true;
      image = "lscr.io/linuxserver/jellyfin";
      extraOptions = [
        "--network=host"
        "--device=/dev/dri:/dev/dri"
      ];
      environment = {
        # DOCKER_MODS = "linuxserver/mods:jellyfin-amd";
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "1000";
        JELLYFIN_PublishedServerUrl = "https://${host}";
      };
      volumes = [
        "${volumePath}:/config"
        "${mediaPath}/movies:/data/movies"
        "${mediaPath}/shows:/data/shows"
      ];
      # ports = [
      #   "0.0.0.0:${toString webPort}:8096"
      #   # "${addr}:8920:8920" # https (optional)
      #   "0.0.0.0:7359:7359/udp" # discovery (optional)
      #   "0.0.0.0:1900:1900/udp" # dnla (optional)
      # ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8096
  ];
  networking.firewall.allowedUDPPorts = [
    7359
    1900
  ];
}
