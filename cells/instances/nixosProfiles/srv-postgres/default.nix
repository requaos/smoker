{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.configProfiles) secrets;
  lib = inputs.nixpkgs.lib // builtins;
in {
  # environment.systemPackages = with nixpkgs; [
  #   (postgresql_12.withPackages (p: [ p.timescaledb ]))
  #   (postgresql_13.withPackages (p: [ p.timescaledb ]))
  #   (postgresql_14.withPackages (p: [ p.timescaledb ]))
  # ];

  services.postgresql = {
    enable = true;
    package = nixpkgs.postgresql_14;
    dataDir = "/var/lib/postgresql/14";
    enableTCPIP = true;

    extraPlugins = with nixpkgs.postgresql_14.pkgs; [
      postgis
      timescaledb
      # age
    ];

    authentication = lib.mkForce ''
      local all all trust
      host all all 0.0.0.0/0 password
      host all all ::0/0 password
    '';

    settings = {
      "port" = 5432;
      "max_worker_processes" = 8;
      # timescaledb
      "shared_preload_libraries" = "timescaledb";
      "timescaledb.max_background_workers" = 8;
    };

    ensureDatabases = [
      # "dash"
      # "poshbot"
      # "rustbot"
    ];

    ensureUsers = [
      # { name = "dash"; ensureDBOwnership = true; }
      # { name = "poshbot"; ensureDBOwnership = true; }
      # { name = "rustbot"; ensureDBOwnership = true; }
    ];

    initialScript = secrets.postgres-initial-script.path;
  };
}
