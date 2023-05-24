{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.hasura-env = {
    file = ../../secrets/hasura-env.age;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      hasura = {
        entryPoints = ["https"];
        rule = "Host(`hasura.poshbot.hanleym.com`)";
        service = "hasura";
      };
    };
    services = {
      hasura = {
        loadBalancer = {
          servers = [{url = "http://127.0.0.1:9100/";}];
        };
      };
    };
  };

  systemd.services.hasura = {
    after = ["network.target"];
    # path = with pkgs; [ openssl ];
    environment = {
      HASURA_GRAPHQL_SERVER_PORT = 9100;
      HASURA_GRAPHQL_ENABLE_CONSOLE = true;
      HASURA_GRAPHQL_DEV_MODE = true;
      HASURA_GRAPHQL_ENABLED_LOG_TYPES = "startup, http-log, webhook-log, websocket-log, query-log";
    };
    serviceConfig = {
      # User = user;
      # Group = group;
      EnvironmentFile = config.age.secrets.hasura-env.path;
      ExecStart = "${pkgs.hasura-graphql-engine}/bin/graphql-engine";
      LimitNOFILE = "1048576";
      PrivateTmp = "true";
      PrivateDevices = "true";
      ProtectHome = "true";
      ProtectSystem = "strict";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      StateDirectory = "hasura";
      StateDirectoryMode = "0700";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };
}
