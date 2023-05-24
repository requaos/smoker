{
  config,
  lib,
  pkgs,
  ...
}: {
  # environment.systemPackages = with pkgs; [
  #   (postgresql_12.withPackages (p: [ p.timescaledb ]))
  #   (postgresql_13.withPackages (p: [ p.timescaledb ]))
  #   (postgresql_14.withPackages (p: [ p.timescaledb ]))
  # ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    dataDir = "/volumes/postgres";
    enableTCPIP = true;
    port = 5432;

    extraPlugins = with pkgs.postgresql_14.pkgs; [
      postgis
      timescaledb
      # age
    ];

    authentication = pkgs.lib.mkForce ''
      local all all trust
      host all all 0.0.0.0/0 password
      host all all ::0/0 password
    '';

    settings = {
      "max_worker_processes" = 8;
      # timescaledb
      "shared_preload_libraries" = "timescaledb";
      "timescaledb.max_background_workers" = 8;
    };

    ensureDatabases = [
      "dash"
      "poshbot"
      "rustbot"
    ];

    ensureUsers = [
      # {
      #   name = "postgres";
      #   ensurePermissions = { "DATABASE postgres" = "ALL PRIVILEGES"; };
      # }
      {
        name = "dash";
        ensurePermissions = {"DATABASE dash" = "ALL PRIVILEGES";};
      }
      {
        name = "poshbot";
        ensurePermissions = {"DATABASE poshbot" = "ALL PRIVILEGES";};
      }
      {
        name = "rustbot";
        ensurePermissions = {"DATABASE rustbot" = "ALL PRIVILEGES";};
      }
    ];

    initialScript = pkgs.writeText "postgres-initialScript" ''
      ALTER USER postgres WITH PASSWORD '6ttxqe9akU8Tpf2J7d7mhN2K';
      ALTER USER authelia WITH PASSWORD 'J6GrqoyNee7SXmFdmQE8oXv6';
      ALTER USER authentik WITH PASSWORD '57ymDdi4RTxAYrBgLxqorY3q';
      ALTER USER bitwarden WITH PASSWORD 'Jis4D76z2kfb68RYTU9B8RhS';
      ALTER USER dash WITH PASSWORD '6xQAimsKttAAjbK24DW4Cbmx';
      ALTER USER metabase WITH PASSWORD '3RFg9sAPTmZ79ThLZah8VA3b';
      ALTER USER rustbot WITH PASSWORD 'fJKtwj4pKuesxPoNU8d3TfMh';
      ALTER USER synapse WITH PASSWORD '5AuRiMYzGHZwsY43ymUDE6w4';
    '';
  };
}
