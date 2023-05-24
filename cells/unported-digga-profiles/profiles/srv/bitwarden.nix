{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.bitwarden-env = {
    file = ../../secrets/bitwarden-env.age;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      bitwarden = {
        entryPoints = ["https"];
        rule = "Host(`bitwarden.requaos.com`)";
        priority = 1; # lowest
        service = "bitwarden";
      };
      bitwarden-websocket = {
        entryPoints = ["https"];
        rule = "Host(`bitwarden.requaos.com`) && PathPrefix(`/notifications/hub`)";
        service = "bitwarden-websocket";
      };
    };
    services = {
      bitwarden = {
        loadBalancer = {
          servers = [{url = "http://127.0.0.1:3011/";}];
        };
      };
      bitwarden-websocket = {
        loadBalancer = {
          servers = [{url = "http://127.0.0.1:3012/";}];
        };
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    # backupDir = "";
    environmentFile = config.age.secrets.bitwarden-env.path;
    config = {
      DOMAIN = "https://bitwarden.requaos.com";
      # DATABASE_URL = "";
      WEBSOCKET_ENABLED = true;
      ENABLE_DB_WAL = false;
      ROCKET_PORT = 3011;
      ROCKET_CLI_COLORS = false;
      SHOW_PASSWORD_HINT = false;
      SIGNUPS_ALLOWED = false;
    };
  };
}
