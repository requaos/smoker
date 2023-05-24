{
  config,
  lib,
  pkgs,
  ...
}: let
  volumePath = "/volumes/vector";
  addr = "127.0.0.1";
  apiPort = 8686;
  prometheusPort = 9089;
in {
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      data_dir = "${volumePath}";
      api = {
        enabled = true;
        address = "${addr}:${toString apiPort}";
      };
      sources = {
        # host_metrics = {
        #   type = "host_metrics";
        # };
        # TODO: figure out why this doesn't work
        # prometheus_remote_write = {
        #   type = "prometheus_remote_write";
        #   address = "${addr}:${toString prometheusPort}"; # listen address
        # };
        journald = {
          type = "journald";
          current_boot_only = true;
          # exclude_units = [ "badservice" ];
          # include_units = [ "ntpd" ];
        };
        # postgres = {
        #   type = "postgresql_metrics";
        #   endpoints = [
        #     "postgresql://postgres:vector@127.0.0.1:5432/postgres"
        #   ];
        # };
      };
      # transforms = {
      #   jounrald_units = {
      #     type = "remap";
      #     inputs = [ "journald" ];
      #     source = ''
      #
      #     '';
      #   };
      # };
      sinks = {
        # TODO: figure out why this doesn't work
        # victoriametrics = {
        #   type = "prometheus_remote_write";
        #   inputs = [
        #     "prometheus_remote_write"
        #   ];
        #   endpoint = "http://127.0.0.1:8428/api/v1/write";
        # };
        loki = {
          type = "loki";
          inputs = [
            "journald"
          ];
          endpoint = "http://127.0.0.01:${toString config.services.loki.configuration.server.http_listen_port}";
          labels = {
            host = config.networking.hostName;
            # syslog_identifier = "{{ .SYSLOG_IDENTIFIER }}";
            boot_id = "{{ ._BOOT_ID }}";
            stream_id = "{{ ._STREAM_ID }}";
            systemd_unit = "{{ ._SYSTEMD_UNIT }}";
            systemd_user_unit = "{{ ._SYSTEMD_USER_UNIT }}";
          };
          encoding = {
            codec = "json";
          };
        };
      };
    };
  };
}
