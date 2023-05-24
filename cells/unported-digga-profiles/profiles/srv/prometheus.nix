{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "prometheus.${config.vars.domain}";
  listenAddr = "127.0.0.1";
  listenPort = 9090;
  # default ports can be found here:
  # https://github.com/prometheus/prometheus/wiki/Default-port-allocations
  nodeExporterPort = 9111; # 9100 is taken
  windowsExporterPort = 9182;
  blockboxExporterPort = 9115;
  postgresExporterPort = 9187;
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
  # boot.kernel.sysctl."kernel.perf_event_paranoid" = 0;

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      prometheus = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "prometheus";
      };
    };
    services = {
      prometheus = {
        loadBalancer = {
          servers = [
            {
              url = "http://${listenAddr}:${toString listenPort}";
            }
          ];
        };
      };
    };
  };

  services.prometheus = {
    enable = true;
    listenAddress = listenAddr;
    port = listenPort;
    remoteWrite = [
      {
        # url = "http://127.0.0.1:9089/api/v1/write"; # vector
        url = "http://127.0.0.1:8428/api/v1/write"; # victoriametrics
      }
    ];
    scrapeConfigs = [
      {
        job_name = "node-exporter-${config.networking.hostName}";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString nodeExporterPort}"
            ];
          }
        ];
      }
      {
        job_name = "windows";
        static_configs = [
          {
            targets = [
              "192.168.1.7:${toString windowsExporterPort}"
            ];
          }
        ];
      }
      {
        job_name = "postgres-exporter";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString postgresExporterPort}"
            ];
          }
        ];
      }
      {
        job_name = "blackbox-icmp";
        scrape_interval = "200ms";
        scrape_timeout = "200ms";
        metrics_path = "/probe";
        params = {
          module = ["blackbox-icmp"];
        };
        static_configs = [
          {
            targets = [
              "192.168.1.1"
              "1.1.1.1"
              "8.8.8.8"
              "185.161.69.26" # https://dedipath.com/network/#dallas
              # ❯ tracepath -4 -b 192.207.0.1
              #  1?: [LOCALHOST]                      pmtu 1500
              #  1:  _gateway (192.168.1.1)                                0.613ms
              #  1:  _gateway (192.168.1.1)                                0.604ms
              #  2:  072-031-129-137.res.spectrum.com (72.31.129.137)     10.198ms
              #  3:  int-0-5-0-8.tamp02-ser1.netops.charter.com (71.44.2.193)   7.802ms
              #  4:  lag-21.tamp04-car1.netops.charter.com (72.31.1.246)   9.077ms
              #  5:  lag-12.tamp04-car2.netops.charter.com (71.44.2.145)  14.971ms asymm  8
              #  6:  lag-14.orld71-car2.netops.charter.com (71.44.1.215)  13.295ms asymm  7
              #  7:  lag-14.orld71-car1.netops.charter.com (71.44.1.211)  15.488ms asymm  6
              #  8:  lag-415-10.orldfljo00w-bcr00.netops.charter.com (66.109.9.138)  19.766ms asymm  7
              #  9:  lag-419.atlngamq46w-bcr00.netops.charter.com (66.109.1.32) 115.131ms asymm 10
              # 10:  lag-302.pr2.atl20.netops.charter.com (66.109.9.103)  23.875ms
              # 11:  no reply
              # 12:  no reply
              # ^C
              # ~ took 8s
              # ❯ tracepath -4 -b 8.8.8.8
              #  1?: [LOCALHOST]                      pmtu 1500
              #  1:  _gateway (192.168.1.1)                                0.625ms
              #  1:  _gateway (192.168.1.1)                                0.579ms
              #  2:  072-031-129-137.res.spectrum.com (72.31.129.137)      8.550ms
              #  3:  int-0-5-0-6.tamp02-ser2.netops.charter.com (71.44.2.255)   8.617ms
              #  4:  lag-21.tamp04-car2.netops.charter.com (72.31.1.194)   8.682ms
              #  5:  lag-10.tamp20-car2.netops.charter.com (72.31.7.130)  11.166ms asymm  6
              #  6:  lag-10.tamp20-car1.netops.charter.com (72.31.7.128)  11.316ms asymm  5
              #  7:  072-031-002-153.res.spectrum.com (72.31.2.153)       17.756ms asymm 11
              #  8:  no reply
              #  9:  no reply
              "072-031-129-137.res.spectrum.com"
              # "int-0-5-0-8.tamp02-ser1.netops.charter.com"
              # "int-0-5-0-6.tamp02-ser2.netops.charter.com"
              "lag-21.tamp04-car1.netops.charter.com"
              "lag-21.tamp04-car2.netops.charter.com"
            ];
          }
        ];
        relabel_configs = [
          {
            source_labels = ["__address__"];
            target_label = "__param_target";
          }
          {
            source_labels = ["__param_target"];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:${toString blockboxExporterPort}";
          }
        ];
      }
    ];
    # alertmanager.enable
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        listenAddress = listenAddr;
        port = nodeExporterPort;
      };
      blackbox = {
        enable = true;
        listenAddress = listenAddr;
        port = blockboxExporterPort;
        configFile = buildYAML {
          name = "blackbox-config.yaml";
          content = {
            modules = {
              blackbox-icmp = {
                prober = "icmp";
                timeout = "5s";
                icmp = {
                  preferred_ip_protocol = "ip4";
                  # source_ip_address = "127.0.0.1";
                };
              };
            };
          };
        };
      };
      # smartctl.enable
      postgres = {
        enable = true;
        listenAddress = listenAddr;
        port = postgresExporterPort;
        runAsLocalSuperUser = true;
      };
    };
  };
}
