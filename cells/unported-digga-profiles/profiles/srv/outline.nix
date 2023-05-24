{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "outline.${config.vars.domain}";
  httpAddr = "127.0.0.1";
  httpPort = 3032;
  uploadBucketHost = lib.strings.removePrefix "." config.services.garage.settings.s3_api.s3_region;
  uploadBucketName = "outline";
  # redisPort = 6379;
  # volumePath = "/volumes/";
in {
  # install the package as well for desktop usage
  environment.systemPackages = with pkgs; [outline];

  age.secrets = {
    outline-secret-key = {
      file = ../../secrets/outline-secret-key.age;
      owner = config.services.outline.user;
      group = config.services.outline.group;
      mode = "660";
    };
    outline-utils-secret = {
      file = ../../secrets/outline-utils-secret.age;
      owner = config.services.outline.user;
      group = config.services.outline.group;
      mode = "660";
    };
    outline-oidc-client-secret = {
      file = ../../secrets/outline-oidc-client-secret.age;
      owner = config.services.outline.user;
      group = config.services.outline.group;
      mode = "660";
    };
    outline-storage-secret-key = {
      file = ../../secrets/outline-storage-secret-key.age;
      owner = config.services.outline.user;
      group = config.services.outline.group;
      mode = "660";
    };
    outline-smtp-password = {
      file = ../../secrets/outline-smtp-password.age;
      owner = config.services.outline.user;
      group = config.services.outline.group;
      mode = "660";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      outline = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "outline";
      };
    };
    # middlewares = { };
    services = {
      outline = {
        loadBalancer = {
          servers = [
            {
              url = "http://${httpAddr}:${toString httpPort}";
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

  services.outline = {
    enable = true;
    enableUpdateCheck = false;
    # How many processes should be spawned. For a rough estimate, divide your server's available memory by 512.
    concurrency = 1;
    port = httpPort;
    publicUrl = "https://${host}";
    # COLLABORATION_URL ???
    databaseUrl = "local";
    redisUrl = "local";
    forceHttps = false; # let trafic do ssl
    # generated with: `nix run nixpkgs#openssl -- rand -hex 32`
    secretKeyFile = config.age.secrets.outline-secret-key.path;
    # generated with: `nix run nixpkgs#openssl -- rand -hex 32`
    utilsSecretFile = config.age.secrets.outline-utils-secret.path;
    # logo = # 60px height logo for the login screen
    # sentryDsn = "";
    # sentryTunnel = "";
    # sequelizeArguments = "--env=production-ssl-disabled"; # ???

    oidcAuthentication = {
      clientId = "outline";
      clientSecretFile = config.age.secrets.outline-oidc-client-secret.path;
      authUrl = "https://auth.${config.vars.domain}/api/oidc/authorization";
      tokenUrl = "https://auth.${config.vars.domain}/api/oidc/token";
      userinfoUrl = "https://auth.${config.vars.domain}/api/oidc/userinfo";
      usernameClaim = "preferred_username";
      displayName = "Authelia";
      scopes = [
        "openid"
        "offline_access"
        "profile"
        "email"
      ];
    };

    storage = {
      # TODO: fix this...
      accessKey = "GK5bef63b9ab68ea363c66b1b1";
      secretKeyFile = config.age.secrets.outline-storage-secret-key.path;
      uploadBucketUrl = "https://${uploadBucketHost}";
      uploadBucketName = uploadBucketName;
      region = config.services.garage.settings.s3_api.s3_region;
      forcePathStyle = true;
    };

    smtp = {
      host = "smtp.gmail.com";
      port = 587;
      secure = true;
      username = config.vars.email;
      passwordFile = config.age.secrets.outline-smtp-password.path;
      fromEmail = "Outline <outline@hanleym.com>";
      replyEmail = "Outline <outline@hanleym.com>";
    };
  };
}
