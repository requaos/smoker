{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "authelia.${config.vars.domain}";
  alias = "auth.${config.vars.domain}";
  addr = "127.0.0.1";
  port = 9091;

  mainInstanceName = config.vars.username;

  secretEnvironmentVariables = {
    AUTHELIA_JWT_SECRET_FILE = config.age.secrets.authelia-jwt-secret.path;
    AUTHELIA_SESSION_SECRET_FILE = config.age.secrets.authelia-session-secret.path;
    AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = config.age.secrets.authelia-storage-encryption-key.path;
    AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = config.age.secrets.authelia-postgres-password.path;
    AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.authelia-smtp-password.path;
    AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET_FILE = config.age.secrets.authelia-oidc-hmac-secret.path;
    AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE = config.age.secrets.authelia-oidc-issuer-private-key.path;
  };

  settings = {
    log.level = "info"; # debug
    server = {
      host = addr;
      port = port;
    };

    default_redirection_url = "https://dashboard.${config.vars.domain}";

    theme = "dark";
    default_2fa_method = "";

    ## Set the path on disk to Authelia assets.
    ## Useful to allow overriding of specific static assets.
    # asset_path = "/config/assets/";

    # headers = {
    #   csp_template = "";
    # };

    totp.issuer = "${config.vars.domain}";

    authentication_backend = {
      file = {
        path = usersFile;
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

    identity_providers = {
      oidc = {
        # provided in environment variables:
        # hmac_secret
        # issuer_private_key
        clients = [
          {
            id = "outline";
            description = "Outline";
            # TODO: how can this be specified in the environment variables?
            # secret = config.age.secrets.authelia-oidc-client-outline-secret.path;
            secret = "$pbkdf2-sha512$310000$KbWfVsvLdvvU7tYhX.TkuA$mTekipaAN1wW2L.h6WenhiulITPiSB4.KBI4K2otvUu3R1A.spVqq/LQQERjKRedLRG3Kjrwq72hHlRszldRWQ";
            public = false;
            authorization_policy = "two_factor";
            redirect_uris = [
              "https://outline.${config.vars.domain}/auth/oidc.callback"
            ];
            scopes = [
              "openid"
              "offline_access"
              "profile"
              "email"
            ];
            userinfo_signing_algorithm = "none";
          }
        ];
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

  configFile = buildYAML {
    name = "configuration.yml";
    content = settings;
  };

  users = {
    ${config.vars.username} = {
      displayname = "${config.vars.fullname}";
      email = "${config.vars.email}";
      password = "$argon2id$v=19$m=65536,t=3,p=4$/nRGJ5GJut3jPSd6EGWA2g$sACIJxrdVxtmQ2lyrnR4DH0CrdMGf+yWTIu58w43GvQ";
      groups = [
        "admins"
      ];
    };
    nivea = {
      displayname = "Nivea";
      email = "niveashan@gmail.com";
      password = "$argon2id$v=19$m=65536,t=3,p=4$Ru1rTVLvA87ldfZpJQe7+Q$cAn8jpkn45WDXQ/gYo3e90L8KwxwCEpI/4OaBVIz5g4";
      groups = [
        "admins"
      ];
    };
  };

  usersFile = buildYAML {
    name = "users.yml";
    content = {
      inherit users;
    };
  };

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
  # install the package as well for cli usage
  environment.systemPackages = with pkgs; [authelia];

  age.secrets = {
    authelia-jwt-secret = {
      file = ../../secrets/authelia-jwt-secret.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-session-secret = {
      file = ../../secrets/authelia-session-secret.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-storage-encryption-key = {
      file = ../../secrets/authelia-storage-encryption-key.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-postgres-password = {
      file = ../../secrets/authelia-postgres-password.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-smtp-password = {
      file = ../../secrets/authelia-smtp-password.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-oidc-hmac-secret = {
      file = ../../secrets/authelia-oidc-hmac-secret.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
    authelia-oidc-issuer-private-key = {
      file = ../../secrets/authelia-oidc-issuer-private-key.age;
      owner = config.services.authelia.instances.${mainInstanceName}.user;
      group = config.services.authelia.instances.${mainInstanceName}.group;
      mode = "660";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      authelia = {
        entryPoints = ["https"];
        rule = "Host(`${host}`, `${alias}`)";
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

  services.authelia.instances = {
    "${mainInstanceName}" = {
      enable = true;

      # secrets
      environmentVariables = {} // secretEnvironmentVariables;
      secrets.manual = true;

      inherit settings;
    };
  };

  # virtualisation.oci-containers.containers = {
  #   authelia = {
  #     autoStart = true;
  #     image = "ghcr.io/authelia/authelia";
  #     extraOptions = [ "--network=host" ];
  #     environment = {
  #       TZ = "America/New_York";
  #     } // secretEnvironmentVariables;
  #     volumes = [
  #       "${configFile}:/config/configuration.yml"
  #       "${usersFile}:/config/users.yml"
  #       "${config.age.secrets.authelia-jwt-secret.path}:${config.age.secrets.authelia-jwt-secret.path}"
  #       "${config.age.secrets.authelia-session-secret.path}:${config.age.secrets.authelia-session-secret.path}"
  #       "${config.age.secrets.authelia-storage-encryption-key.path}:${config.age.secrets.authelia-storage-encryption-key.path}"
  #       "${config.age.secrets.authelia-postgres-password.path}:${config.age.secrets.authelia-postgres-password.path}"
  #       "${config.age.secrets.authelia-smtp-password.path}:${config.age.secrets.authelia-smtp-password.path}"
  #     ];
  #     ports = [
  #       "${addr}:${toString port}:9091"
  #     ];
  #   };
  # };
}
