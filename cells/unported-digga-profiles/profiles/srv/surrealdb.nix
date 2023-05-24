{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "127.0.0.1";
  port = 15000;
  volumePath = "/volumes/surrealdb";
in {
  environment.systemPackages = with pkgs; [
    surrealdb
  ];

  age.secrets = {
    surrealdb-username = {
      file = ../../secrets/surrealdb-username.age;
      owner = "surrealdb";
      group = "nobody";
      mode = "600";
    };
    surrealdb-password = {
      file = ../../secrets/surrealdb-password.age;
      owner = "surrealdb";
      group = "nobody";
      mode = "600";
    };
  };

  services.surrealdb = {
    enable = true;
    dbPath = "file://${volumePath}";

    host = host;
    port = port;

    userNamePath = config.age.secrets.surrealdb-username.path;
    passwordPath = config.age.secrets.surrealdb-password.path;
  };

  # virtualisation.oci-containers.containers = {
  #   surrealdb = {
  #     autoStart = true;
  #     image = "surrealdb/surrealdb";
  #     extraOptions = [ "--network=host" ];
  #     volumes = [
  #       "${volumePath}:/surrealdb"
  #     ];
  #     # ports = [
  #     #   "127.0.0.1:${toString port}:${toString port}"
  #     # ];
  #   };
  # };
}
