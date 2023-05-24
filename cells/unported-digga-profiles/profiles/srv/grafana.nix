{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "grafana.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 3010;
  volumePath = "/volumes/grafana";
in {
  age.secrets = {
    grafana-secret-key = {
      file = ../../secrets/grafana-secret-key.age;
      owner = "grafana";
      group = "grafana";
      mode = "400";
    };
    grafana-admin-password = {
      file = ../../secrets/grafana-admin-password.age;
      owner = "grafana";
      group = "grafana";
      mode = "400";
    };
    grafana-database-password = {
      file = ../../secrets/grafana-database-password.age;
      owner = "grafana";
      group = "grafana";
      mode = "400";
    };
    grafana-smtp-password = {
      file = ../../secrets/grafana-smtp-password.age;
      owner = "grafana";
      group = "grafana";
      mode = "400";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      grafana = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "grafana";
      };
    };
    services = {
      grafana = {
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
    ensureDatabases = ["grafana"];
    ensureUsers = [
      {
        name = "grafana";
        ensurePermissions = {"DATABASE grafana" = "ALL PRIVILEGES";};
      }
    ];
  };

  services.grafana = {
    enable = true;
    dataDir = volumePath;
    settings = {
      server = {
        root_url = "https://${host}";
        domain = host;
        http_addr = addr;
        http_port = port;
      };
      analytics = {
        reporting_enabled = false;
      };
      security = {
        secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
        admin_user = config.vars.username;
        admin_password = "$__file{${config.age.secrets.grafana-admin-password.path}}";
      };
      database = {
        type = "postgres";
        host = "127.0.0.1:5432";
        name = "grafana";
        user = "grafana";
        password = "$__file{${config.age.secrets.grafana-database-password.path}}";
      };
      smtp = {
        enabled = true;
        host = "smtp.gmail.com:587";
        from_address = "grafana@${config.vars.domain}";
        user = config.vars.email;
        password = "$__file{${config.age.secrets.grafana-smtp-password.path}}";
      };
    };
  };
}
