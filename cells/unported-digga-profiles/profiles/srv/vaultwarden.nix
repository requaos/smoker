{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "vaultwarden.${config.vars.domain}";
  alias = "bitwarden.${config.vars.domain}";
  httpPort = 3011;
  websocketPort = 3012;
  volumePath = "/volumes/vaultwarden";
in {
  age.secrets.vaultwarden-env = {
    file = ../../secrets/vaultwarden-env.age;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      vaultwarden = {
        entryPoints = ["https"];
        rule = "Host(`${host}`, `${alias}`)";
        service = "vaultwarden";
      };
      vaultwarden-websocket = {
        entryPoints = ["https"];
        rule = "Host(`${host}`, `${alias}`) && PathPrefix(`/notifications/hub`)";
        service = "vaultwarden-websocket";
      };
    };
    services = {
      vaultwarden = {
        loadBalancer = {
          servers = [{url = "http://127.0.0.1:${toString httpPort}";}];
        };
      };
      vaultwarden-websocket = {
        loadBalancer = {
          servers = [{url = "http://127.0.0.1:${toString websocketPort}";}];
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["bitwarden"];
    ensureUsers = [
      {
        name = "bitwarden";
        ensurePermissions = {"DATABASE bitwarden" = "ALL PRIVILEGES";};
      }
    ];
  };

  # services.vaultwarden = {
  #   enable = true;
  #   dbBackend = "postgresql";
  #   # backupDir = "";
  #   environmentFile = config.age.secrets.vaultwarden-env.path;
  #   config = {
  #     DATA_DIR = "${volumePath}";
  #     # DATABASE_URL = ""; # set by secrets
  #     # IP_HEADER = "X-Client-IP";
  #     DOMAIN = "https://${host}";
  #     WEBSOCKET_ENABLED = true;
  #     WEBSOCKET_PORT = websocketPort;
  #     # EXTENDED_LOGGING = true;
  #     # USE_SYSLOG = false;
  #     # LOG_LEVEL = "info";
  #     ENABLE_DB_WAL = false;
  #     SHOW_PASSWORD_HINT = false;
  #     SIGNUPS_ALLOWED = false;
  #     SIGNUPS_VERIFY = true;
  #     # ADMIN_TOKEN = ""; // set by secrets
  #     PASSWORD_ITERATIONS = "600000";
  #     ROCKET_PORT = httpPort;
  #   };
  # };

  virtualisation.oci-containers.containers = {
    vaultwarden = {
      autoStart = true;
      image = "vaultwarden/server";
      extraOptions = ["--network=host"];
      environmentFiles = [
        config.age.secrets.vaultwarden-env.path
      ];
      environment = {
        DATA_DIR = "/data";
        # DATABASE_URL = ""; # set by secrets
        # IP_HEADER = "X-Client-IP";
        DOMAIN = "https://${host}";
        WEBSOCKET_ENABLED = "true";
        WEBSOCKET_PORT = "${toString websocketPort}";
        # EXTENDED_LOGGING = true;
        # USE_SYSLOG = false;
        # LOG_LEVEL = "info";
        ENABLE_DB_WAL = "false";
        SHOW_PASSWORD_HINT = "false";
        SIGNUPS_ALLOWED = "false";
        SIGNUPS_VERIFY = "true";
        # ADMIN_TOKEN = ""; // set by secrets
        PASSWORD_ITERATIONS = "600000";
        ROCKET_PORT = "${toString httpPort}";
        SMTP_HOST = "smtp.gmail.com";
        SMTP_SECURIRY = "starttls";
        SMTP_PORT = "587";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_FROM = "vaultwarden@hanleym.com";
        # SMTP_USERNAME = ""; // set by secrets
        # SMTP_PASSWORD = ""; // set by secrets
      };
      volumes = [
        "${volumePath}:/data"
      ];
      # ports = [
      #   "127.0.0.1:${toString httpPort}:${toString httpPort}"
      #   "127.0.0.1:${toString websocketPort}:${toString websocketPort}"
      # ];
    };
  };
}
