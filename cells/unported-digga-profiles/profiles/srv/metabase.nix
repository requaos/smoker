{
  config,
  lib,
  pkgs,
  ...
}: let
  addr = "127.0.0.1";
  port = 3003;
  # volumePath = "/volumes/metabase";
in {
  age.secrets.metabase-postgres-password = {
    file = ../../secrets/metabase-postgres-password.age;
    owner = "1000";
    group = "1000";
    mode = "600";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      metabase = {
        entryPoints = ["https"];
        rule = "Host(`metabase.hanleym.com`)";
        service = "metabase";
      };
    };
    services = {
      metabase = {
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
    ensureDatabases = ["metabase"];
    ensureUsers = [
      {
        name = "metabase";
        ensurePermissions = {"DATABASE metabase" = "ALL PRIVILEGES";};
      }
    ];
  };

  virtualisation.oci-containers.containers = {
    metabase = {
      extraOptions = ["--network=host"];
      image = "metabase/metabase";
      environment = {
        MB_JETTY_PORT = "${toString port}";
        # MB_DB_FILE = "/data/metabase.db";
        MB_DB_TYPE = "postgres";
        MB_DB_HOST = "host.containers.internal";
        MB_DB_PORT = "5432";
        MB_DB_DBNAME = "metabase";
        MB_DB_USER = "metabase";
        MB_DB_PASS_FILE = config.age.secrets.metabase-postgres-password.path;
        MUID = "1000";
        MGID = "1000";
      };
      volumes = [
        "${config.age.secrets.metabase-postgres-password.path}:${config.age.secrets.metabase-postgres-password.path}"
        # "${volumePath}:/data"
      ];
      # ports = [
      #   "${addr}:${toString port}:3000"
      # ];
    };
  };
}
