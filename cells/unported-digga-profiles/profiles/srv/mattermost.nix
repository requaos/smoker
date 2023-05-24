{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "chat.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 8065;
  volumePath = "/volumes/mattermost";
in {
  # age.secrets = {
  #   mattermost-secret-key = {
  #     file = ../../secrets/mattermost-secret-key.age;
  #     owner = "mattermost";
  #     group = "mattermost";
  #     mode = "400";
  #   };
  #   mattermost-admin-password = {
  #     file = ../../secrets/mattermost-admin-password.age;
  #     owner = "mattermost";
  #     group = "mattermost";
  #     mode = "400";
  #   };
  #   mattermost-database-password = {
  #     file = ../../secrets/mattermost-database-password.age;
  #     owner = "mattermost";
  #     group = "mattermost";
  #     mode = "400";
  #   };
  #   mattermost-smtp-password = {
  #     file = ../../secrets/mattermost-smtp-password.age;
  #     owner = "mattermost";
  #     group = "mattermost";
  #     mode = "400";
  #   };
  # };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      mattermost = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "mattermost";
      };
    };
    services = {
      mattermost = {
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

  # database is created by the mattermost module's `localDatabaseCreate` setting
  # services.postgresql = {
  #   ensureDatabases = [ "mattermost" ];
  #   ensureUsers = [{
  #     name = "mattermost";
  #     ensurePermissions = { "DATABASE mattermost" = "ALL PRIVILEGES"; };
  #   }];
  # };

  services.mattermost = {
    enable = true;
    listenAddress = "${addr}:${toString port}";
    siteUrl = "https://${host}";
    siteName = "Mattermost";
    statePath = volumePath;
    localDatabaseCreate = true;
    # plugins = [ ];
  };
}
