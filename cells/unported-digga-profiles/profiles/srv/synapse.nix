{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "matrix.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 8008;
  volumePath = "/volumes/synapse";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      synapse = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "synapse";
      };
    };
    services = {
      synapse = {
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

  services.postgresql = {
    ensureDatabases = ["synapse"];
    ensureUsers = [
      {
        name = "synapse";
        ensurePermissions = {"DATABASE synapse" = "ALL PRIVILEGES";};
      }
    ];
  };

  services.matrix-synapse = {
    enable = true;
    dataDir = volumePath;
    # extraConfigFiles = []; # used for secrets
    settings = {
      server_name = "hanleym.com";
      public_baseurl = "https://example.com:8448/";
      listeners = [
        {
          bind_addresses = [addr];
          port = port;
          type = "http";
          x_forwarded = true;
          tls = false;
          resources = [
            {
              compress = true;
              names = ["client"];
            }
            {
              compress = false;
              names = ["federation"];
            }
          ];
        }
      ];
      database = {
        name = "psycopg2";
        args = {
          user = "synapse";
          database = "synapse";
        };
      };
    };
  };
}
