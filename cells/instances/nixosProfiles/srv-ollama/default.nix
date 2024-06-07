{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.configProfiles) loopback domain;

  host = "ollama.${domain}";
  port = 11434;
  # volumePath = "/var/lib/ollama";
  # volumePath = "/var/lib/docker-ollama";
in {
  # environment.systemPackages = with nixpkgs; [
  #   ollama
  # ];

  # services.authelia.instances.main.settings.access_control.rules = [
  #   {
  #     domain = host;
  #     networks = ["internal"];
  #     policy = "bypass";
  #   }
  # ];

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      ollama = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        # middlewares = ["authelia@file"];
        service = "ollama";
      };
    };
    services = {
      ollama = {
        loadBalancer = {
          servers = [
            {
              url = "http://${loopback}:${toString port}";
              # TODO: just proxying to windows to use the 4090; get a better GPU here...
              # url = "http://192.168.1.3:${toString port}";
            }
          ];
        };
      };
    };
  };

  # TODO: reduce builds times?
  services.ollama = {
    enable = true;
    host = loopback;
    port = port;
    # listenAddress = "${loopback}:${toString port}";
    acceleration = "cuda";
  };

  # TODO: get this working
  # virtualisation.oci-containers.containers = {
  #   ollama = {
  #     image = "ollama/ollama:rocm";
  #     extraOptions = [
  #       # "--network=host"
  #       "--device=/dev/dri"
  #       "--device=/dev/kfd"
  #     ];
  #     volumes = [
  #       "${volumePath}:/root/.ollama"
  #     ];
  #     ports = [
  #       "${loopback}:${toString port}:8000"
  #     ];
  #   };
  # };
}
