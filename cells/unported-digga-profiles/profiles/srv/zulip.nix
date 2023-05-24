{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "chat.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 9091;

  # functions
  buildYAML = {
    name,
    content,
  }:
    pkgs.runCommand "${name}"
    {
      buildInputs = with pkgs; [yj];
      preferLocalBuild = true;
    } ''
      yj -r \
      < ${
        pkgs.writeText "${name}.json" (builtins.toJSON content)
      } \
      > $out
    '';
in {
  age.secrets = {
    authelia-jwt-secret = {
      file = ../../secrets/authelia-jwt-secret.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    authelia-session-secret = {
      file = ../../secrets/authelia-session-secret.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    authelia-storage-encryption-key = {
      file = ../../secrets/authelia-storage-encryption-key.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    authelia-storage-postgres-password = {
      file = ../../secrets/authelia-storage-postgres-password.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
    authelia-notifier-smtp-password = {
      file = ../../secrets/authelia-notifier-smtp-password.age;
      owner = "1000";
      group = "1000";
      mode = "600";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      authelia = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "authelia";
      };
    };
    middlewares = {
      authelia = {
        forwardAuth = {
          address = "http://${addr}:${toString port}/api/verify";
          trustForwardHeader = true;
          authResponseHeaders = [
            "Remote-User"
            "Remote-Groups"
            "Remote-Email"
            "Remote-Name"
          ];
        };
      };
    };
    services = {
      authelia = {
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
    ensureDatabases = ["authelia"];
    ensureUsers = [
      {
        name = "authelia";
        ensurePermissions = {"DATABASE authelia" = "ALL PRIVILEGES";};
      }
    ];
  };

  virtualisation.oci-containers.containers = {
    authelia = {
      autoStart = true;
      image = "ghcr.io/authelia/authelia";
      extraOptions = ["--network=host"];
      environment = {
        TZ = "America/New_York";
        AUTHELIA_JWT_SECRET_FILE = config.age.secrets.authelia-jwt-secret.path;
        AUTHELIA_SESSION_SECRET_FILE = config.age.secrets.authelia-session-secret.path;
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = config.age.secrets.authelia-storage-encryption-key.path;
        AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = config.age.secrets.authelia-storage-postgres-password.path;
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.authelia-notifier-smtp-password.path;
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

              ## Set the path on disk to Authelia assets.
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
                name = "authelia";
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
                  database = "authelia";
                  username = "authelia";
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
          "${configFile}:/config/configuration.yml"
          "${usersFile}:/config/users.yml"
          "${config.age.secrets.authelia-jwt-secret.path}:${config.age.secrets.authelia-jwt-secret.path}"
          "${config.age.secrets.authelia-session-secret.path}:${config.age.secrets.authelia-session-secret.path}"
          "${config.age.secrets.authelia-storage-encryption-key.path}:${config.age.secrets.authelia-storage-encryption-key.path}"
          "${config.age.secrets.authelia-storage-postgres-password.path}:${config.age.secrets.authelia-storage-postgres-password.path}"
          "${config.age.secrets.authelia-notifier-smtp-password.path}:${config.age.secrets.authelia-notifier-smtp-password.path}"
        ]
      );
      ports = [
        "${addr}:${toString port}:9091"
      ];
    };
  };
}
