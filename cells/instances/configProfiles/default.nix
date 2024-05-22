{
  inputs,
  cell,
}: let
  # load = cell.lib.load inputs cell;
  lib = inputs.nixpkgs.lib // builtins;

  fullname = "Neil Skinner";
  username = "req";
  emailuser = "req";
  domain = "requaos.com";
  loopback = "127.0.0.1";

  secretNames = [
    "postgres-initial-script"
    "windmill-database-url"
    # "authelia-jwt-secret"
    # "authelia-oidc-hmac-secret"
    # "authelia-oidc-issuer-private-key"
    # "authelia-postgres-password"
    # "authelia-session-secret"
    # "authelia-smtp-password"
    # "authelia-storage-encryption-key"
    # "authentik-postgres-password"
    # "authentik-secret-key"
    # "authentik-smtp-password"
    # "discord-jmusicbot-token"
    # "github-runner-token"
    # "hasura-env"
    # "metabase-postgres-password"
    # "outline-oidc-client-secret"
    # "outline-secret-key"
    # "outline-smtp-password"
    # "outline-storage-secret-key"
    # "outline-utils-secret"
    # "wifi-passwords-env"
  ];

  secrets = builtins.listToAttrs (lib.map
    (path: {
      # path = "/run/agenix/${path}";
      name = path;
      value = {
        path = "/sec/${path}";
      };
    })
    secretNames);
in {
  inherit username domain loopback fullname secrets;

  email = "${emailuser}@${domain}";
}
