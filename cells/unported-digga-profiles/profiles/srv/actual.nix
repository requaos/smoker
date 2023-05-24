{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "actual.${config.vars.domain}";
  alias = "budget.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 5006;
  volumePath = "/volumes/actual";
in {
  # age.secrets = {
  #   actual-jwt-secret = {
  #     file = ../../secrets/actual-jwt-secret.age;
  #     owner = "1000";
  #     group = "1000";
  #     mode = "600";
  #   };
  #   actual-session-secret = {
  #     file = ../../secrets/actual-session-secret.age;
  #     owner = "1000";
  #     group = "1000";
  #     mode = "600";
  #   };
  #   actual-storage-encryption-key = {
  #     file = ../../secrets/actual-storage-encryption-key.age;
  #     owner = "1000";
  #     group = "1000";
  #     mode = "600";
  #   };
  #   actual-storage-postgres-password = {
  #     file = ../../secrets/actual-storage-postgres-password.age;
  #     owner = "1000";
  #     group = "1000";
  #     mode = "600";
  #   };
  #   actual-notifier-smtp-password = {
  #     file = ../../secrets/actual-notifier-smtp-password.age;
  #     owner = "1000";
  #     group = "1000";
  #     mode = "600";
  #   };
  # };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      actual = {
        entryPoints = ["https"];
        rule = "Host(`${host}`, `${alias}`)";
        service = "actual";
      };
    };
    # middlewares = {
    #   actual = {
    #     forwardAuth = {
    #       address = "http://${addr}:${toString port}/api/verify";
    #       trustForwardHeader = true;
    #       authResponseHeaders = [
    #         "Remote-User"
    #         "Remote-Groups"
    #         "Remote-Email"
    #         "Remote-Name"
    #       ];
    #     };
    #   };
    # };
    services = {
      actual = {
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

  # services.postgresql = {
  #   ensureDatabases = [ "actual" ];
  #   ensureUsers = [{
  #     name = "actual";
  #     ensurePermissions = { "DATABASE actual" = "ALL PRIVILEGES"; };
  #   }];
  # };

  virtualisation.oci-containers.containers = {
    actual = {
      autoStart = true;
      image = "ghcr.io/actualbudget/actual-server";
      environment = {
        TZ = "America/New_York";
        actual_JWT_SECRET_FILE = config.age.secrets.actual-jwt-secret.path;
        actual_SESSION_SECRET_FILE = config.age.secrets.actual-session-secret.path;
        actual_STORAGE_ENCRYPTION_KEY_FILE = config.age.secrets.actual-storage-encryption-key.path;
        actual_STORAGE_POSTGRES_PASSWORD_FILE = config.age.secrets.actual-storage-postgres-password.path;
        actual_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.actual-notifier-smtp-password.path;
      };
      volumes = (
        let
          configFile = buildYAML {
            name = "configuration.yml";
            content = {
              log.level = "info"; # debug
              theme = "light";
              # jwt_secret = "";
              default_redirection_url = "https://dashboard.${config.vars.domain}";
              # default_2fa_method = "";
              server = {
                host = addr;
                port = port;
              };

              ## Set the path on disk to actual assets.
              ## Useful to allow overriding of specific static assets.
              # asset_path = "/config/assets/";

              # headers = {
              #   csp_template = "";
              # };

              totp.issuer = "${config.vars.domain}";

              authentication_backend = {
                file = {
                  path = "/config/users.yml";
                  # password = {
                  #   algorithm = "sha2crypt";
                  #   sha2crypt = {
                  #     variant = "sha512";
                  #   };
                  # };
                };
              };

              access_control = {
                default_policy = "deny";
                rules = [
                  {
                    domain = "bitwarden.hanleym.com";
                    policy = "two_factor";
                  }
                ];
                # Rules applied to everyone
                # - domain: public.example.com
                #   policy: bypass
                # - domain: traefik.example.com
                #   policy: one_factor
                # - domain: secure.example.com
                #   policy: two_factor
              };

              session = {
                name = "actual";
                domain = "${config.vars.domain}";
                expiration = "1h";
                inactivity = "15m";
                remember_me_duration = "1M";
              };

              regulation = {
                max_retries = 3;
                find_time = 120;
                ban_time = 300;
              };

              storage = {
                postgres = {
                  host = "127.0.0.1";
                  port = 5432;
                  database = "actual";
                  username = "actual";
                };
              };

              notifier = {
                smtp = {
                  host = "smtp.gmail.com";
                  port = 587;
                  sender = config.vars.email;
                  username = config.vars.email;
                };
              };
            };
          };
          usersFile = buildYAML {
            name = "users.yml";
            content = {
              users = {
                ${config.vars.username} = {
                  displayname = "${config.vars.fullname}";
                  email = "${config.vars.email}";
                  password = "$argon2id$v=19$m=65536,t=3,p=4$/nRGJ5GJut3jPSd6EGWA2g$sACIJxrdVxtmQ2lyrnR4DH0CrdMGf+yWTIu58w43GvQ";
                  groups = [
                    "admins"
                  ];
                };
              };
            };
          };
        in [
          "${config.age.secrets.actual-jwt-secret.path}:${config.age.secrets.actual-jwt-secret.path}"
          "${config.age.secrets.actual-session-secret.path}:${config.age.secrets.actual-session-secret.path}"
          "${config.age.secrets.actual-storage-encryption-key.path}:${config.age.secrets.actual-storage-encryption-key.path}"
          "${config.age.secrets.actual-storage-postgres-password.path}:${config.age.secrets.actual-storage-postgres-password.path}"
          "${config.age.secrets.actual-notifier-smtp-password.path}:${config.age.secrets.actual-notifier-smtp-password.path}"
          "${volumePath}/server-files:/app/server-files"
          "${volumePath}/user-files:/app/user-files"
        ]
      );
      ports = [
        "${addr}:${toString port}:5006"
      ];
    };
  };
}
