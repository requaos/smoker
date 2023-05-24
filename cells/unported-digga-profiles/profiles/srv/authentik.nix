{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "auth.${config.vars.domain}";
  httpAddr = "127.0.0.1";
  httpPort = 9092; # 9091???
  redisPort = 6379;
  volumePath = "/volumes/authentik";
  mediaPath = "${volumePath}/media";
  templatesPath = "${volumePath}/templates";
  redisPath = "${volumePath}/redis";
in {
  age.secrets = {
    authentik-secret-key = {
      file = ../../secrets/authentik-secret-key.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    authentik-postgres-password = {
      file = ../../secrets/authentik-postgres-password.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    # authentik-redis-password = {
    #   file = ../../secrets/authentik-redis-password.age;
    #   owner = "1000";
    #   group = "1000";
    #   mode = "600";
    # };
    authentik-smtp-password = {
      file = ../../secrets/authentik-smtp-password.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      authentik = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "authentik";
      };
      authentik-outpost = {
        entryPoints = ["https"];
        rule = "PathPrefix(`/outpost.goauthentik.io/`)";
        priority = 1000;
        service = "authentik-outpost";
      };
    };
    middlewares = {
      authentik = {
        forwardAuth = {
          address = "http://${httpAddr}:${toString httpPort}/outpost.goauthentik.io/auth/traefik";
          trustForwardHeader = true;
          authResponseHeaders = [
            "X-authentik-username"
            "X-authentik-groups"
            "X-authentik-email"
            "X-authentik-name"
            "X-authentik-uid"
            "X-authentik-jwt"
            "X-authentik-meta-jwks"
            "X-authentik-meta-outpost"
            "X-authentik-meta-provider"
            "X-authentik-meta-app"
            "X-authentik-meta-version"
          ];
        };
      };
    };
    services = {
      authentik = {
        loadBalancer = {
          servers = [
            {
              url = "http://${httpAddr}:${toString httpPort}";
            }
          ];
        };
      };
      authentik-outpost = {
        loadBalancer = {
          servers = [
            {
              url = "http://${httpAddr}:${toString httpPort}/outpost.goauthentik.io";
            }
          ];
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["authentik"];
    ensureUsers = [
      {
        name = "authentik";
        ensurePermissions = {"DATABASE authentik" = "ALL PRIVILEGES";};
      }
    ];
  };

  virtualisation.oci-containers.containers = let
    authentikShared = {
      autoStart = true;
      extraOptions = ["--network=host"];
      image = "ghcr.io/goauthentik/server:2023.2.2";
      environment = {
        TZ = "America/New_York";
        AUTHENTIK_SECRET_KEY = "file://${config.age.secrets.authentik-secret-key.path}";
        # AUTHENTIK_LOG_LEVEL = "debug";
        # AUTHENTIK_DISABLE_UPDATE_CHECK = "false";
        # AUTHENTIK_GEOIP = "/geoip/GeoLite2-City.mmdb";
        AUTHENTIK_COOKIE_DOMAIN = "${config.vars.domain}";
        AUTHENTIK_LISTEN__HTTP = "${httpAddr}:${toString httpPort}";
        # AUTHENTIK_LISTEN__HTTPS = "9443";
        # AUTHENTIK_LISTEN__LDAP = "3389";
        # AUTHENTIK_LISTEN__LDAPS = "6636";
        # AUTHENTIK_LISTEN__METRICS = "9300";
        AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";
        AUTHENTIK_POSTGRESQL__PORT = "5432";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__PASSWORD = "file://${config.age.secrets.authentik-postgres-password.path}";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_REDIS__HOST = "127.0.0.1";
        AUTHENTIK_REDIS__PORT = toString redisPort;
        # AUTHENTIK_REDIS__PASSWORD = "file://${config.age.secrets.authentik-redis-password.path}";
        AUTHENTIK_EMAIL__HOST = "smtp.gmail.com";
        AUTHENTIK_EMAIL__PORT = "587";
        AUTHENTIK_EMAIL__FROM = "auth@${config.vars.domain}";
        AUTHENTIK_EMAIL__USERNAME = config.vars.email;
        AUTHENTIK_EMAIL__PASSWORD = "file://${config.age.secrets.authentik-smtp-password.path}";
        AUTHENTIK_EMAIL__USE_TLS = "true";
      };
      volumes = [
        "${config.age.secrets.authentik-secret-key.path}:${config.age.secrets.authentik-secret-key.path}"
        "${config.age.secrets.authentik-postgres-password.path}:${config.age.secrets.authentik-postgres-password.path}"
        # "${config.age.secrets.authentik-redis-password.path}:${config.age.secrets.authentik-redis-password.path}"
        "${config.age.secrets.authentik-smtp-password.path}:${config.age.secrets.authentik-smtp-password.path}"
        "${mediaPath}:/media"
        "${templatesPath}:/templates"
      ];
    };
  in {
    authentik =
      authentikShared
      // {
        cmd = ["server"];
        # ports = [];
      };
    authentik-worker =
      authentikShared
      // {
        cmd = ["worker"];
        # user = "root";
        # volumes = [
        #   "/var/run/docker.sock:/var/run/docker.sock"
        # ];
      };
    redis = {
      autoStart = true;
      image = "docker.io/library/redis";
      cmd = ["--save" "60" "1" "--loglevel" "warning"]; # start with persistent storage
      volumes = [
        "${redisPath}:/data"
      ];
      ports = [
        "127.0.0.1:${toString redisPort}:6379"
      ];
    };
  };
}
