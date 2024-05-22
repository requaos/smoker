{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.configProfiles) loopback domain;
  # lib = nixpkgs.lib // builtins;

  host = "surrealdb.${domain}";
  port = 6543;
  volumePath = "/var/lib/surrealdb";
in {
  networking.firewall.allowedTCPPorts = [port];

  environment.systemPackages = with nixpkgs; [
    surrealdb-migrations
    # surrealist
  ];

  # services.authelia.instances.main.settings.access_control.rules = [
  #   {
  #     domain = host;
  #     networks = ["internal"];
  #     policy = "bypass";
  #   }
  # ];

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      surrealdb = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        # middlewares = [ "authelia@file" ];
        service = "surrealdb";
      };
    };
    services = {
      surrealdb = {
        loadBalancer = {
          servers = [
            {
              url = "http://${loopback}:${toString port}";
            }
          ];
        };
      };
    };
  };

  services.surrealdb = {
    enable = true;
    # package = nixpkgs-hanleym.legacyPackages.surrealdb.overrideAttrs (old: {
    #   meta = lib.removeAttrs old.meta ["license"];
    #   # doCheck = false;
    # });
    host = "0.0.0.0";
    port = port;
    dbPath = "file:///var/lib/surrealdb/";
    extraFlags = [
      "--allow-all"
      "--auth"
      # "--username"
      # "root"
      # "--password"
      # "root"
    ];
  };

  # virtualisation.oci-containers.containers = {
  #   surrealdb = {
  #     image = "docker.io/surrealdb/surrealdb:latest";
  #     user = "62428:62428";
  #     extraOptions = [ "--network=host" ];
  #     entrypoint = "/surreal";
  #     environment = {
  #       SURREAL_BIND = "0.0.0.0:${toString port}";
  #     };
  #     cmd = [
  #       "start"
  #       # "--log" "trace"
  #       "--allow-all"
  #       "--auth"
  #       # "--user" "root"
  #       # "--pass" "root"
  #       "file:///var/lib/surrealdb/"
  #     ];
  #     volumes = [
  #       "${volumePath}:/var/lib/surrealdb"
  #     ];
  #     # ports = [
  #     #   "${loopback}:${toString port}:8000"
  #     # ];
  #   };
  # };

  virtualisation.oci-containers.containers = {
    surrealdb = {
      image = "docker.io/surrealdb/surrealdb:latest";
      user = "62428:62428";
      # extraOptions = [ "--network=host" ];
      entrypoint = "/surreal";
      cmd = [
        "start"
        # "--log" "trace"
        "--allow-all"
        "--auth"
        # "--user" "root"
        # "--pass" "root"
        "file:///var/lib/surrealdb/"
      ];
      volumes = [
        "${volumePath}:/var/lib/surrealdb"
      ];
      ports = [
        "${loopback}:${toString port}:8000"
      ];
    };
  };
}
