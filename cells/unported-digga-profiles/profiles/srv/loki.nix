{
  config,
  lib,
  pkgs,
  ...
}: let
  addr = "127.0.0.1";
  port = 3100;
  volumePath = "/volumes/loki";
in {
  services.loki = {
    enable = true;
    dataDir = volumePath;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = port;
      };
      ingester = {
        lifecycler = {
          address = addr;
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };
      schema_config = {
        configs = [
          {
            from = "2020-01-01";
            store = "boltdb";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "168h";
            };
          }
        ];
      };
      storage_config = {
        boltdb = {
          directory = "${volumePath}/index";
        };
        filesystem = {
          directory = "${volumePath}/chunks";
        };
      };
      limits_config = {
        enforce_metric_name = false;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
        ingestion_rate_mb = 32;
        ingestion_burst_size_mb = 64;
      };
    };
  };
}
