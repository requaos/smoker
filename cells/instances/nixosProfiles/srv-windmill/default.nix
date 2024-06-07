{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib stdenv fetchFromGitHub buildNpmPackage;
  inherit (cell.configProfiles) loopback domain secrets;
  # lib = nixpkgs.lib // builtins;

  host = "windmill.${domain}";
  port = 7000;
  lspPort = 7001;
  #http://localhost:40189/
  #volumePath = "/var/lib/windmill";

  windmill = inputs.windmill.packages.windmill;
in {
  disabledModules = [
    "services/web-apps/windmill.nix"
  ];
  imports = [
    ../../nixosOverrides/windmill.nix
  ];

  environment.systemPackages = [
    windmill
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
      windmill = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        # middlewares = ["authelia@file"];
        service = "windmill";
      };
    };
    services = {
      windmill = {
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

  services.postgresql = {
    ensureDatabases = ["windmill"];
    ensureUsers = [
      {
        name = "windmill";
        ensureDBOwnership = true;
      }
    ];
  };

  services.windmill = {
    enable = true;
    package = windmill;
    baseUrl = "https://${host}";
    serverPort = port;
    lspPort = lspPort;
    database = {
      urlPath = secrets.windmill-database-url.path;
      createLocally = true;
      name = "windmill";
      #user = "windmill";
    };
  };
}
