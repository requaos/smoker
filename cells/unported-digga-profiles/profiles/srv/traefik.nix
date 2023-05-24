{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  baseDomain = config.vars.domain;
in {
  #age.secrets.cloudflare-dns-api-token = {
  #  file = ../../secrets/cloudflare-dns-api-token.age;
  #  owner = "traefik";
  #  group = "traefik";
  #  mode = "400";
  #};

  systemd.services.traefik.environment = {
    # CLOUDFLARE_EMAIL = config.vars.email;
    # CLOUDFLARE_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-api-token.path;
  };

  # networking.firewall.allowedTCPPorts = [ 10080 10443 8883 ];
  # networking.firewall.allowedUDPPorts = [ 10080 10443 8883 ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      global = {
        sendAnonymousUsage = false;
        checkNewVersion = false;
      };

      log = {
        # level = "DEBUG";
        level = "INFO";
      };

      api = {
        dashboard = true;
      };

      entryPoints = {
        http = {
          address = ":80/tcp";
          http = {
            redirections = {
              entryPoint = {
                scheme = "https";
                to = "https";
              };
            };
          };
        };
        https = {
          address = ":443/tcp";
          http = {
            # middlewares = [ "whitelist@file" ];
            tls = {
              certResolver = "cloudflare";
              domains = [
                {main = "*.${baseDomain}";}
                {main = "*.poshbot.${baseDomain}";}
              ];
            };
          };
        };
        # mqtts = {
        #   address = ":8883";
        # };
      };

      # providers = {
      #   docker = {
      #     endpoint = "unix:///var/run/docker.sock";
      #     exposedByDefault = false;
      #     watch = true;
      #   };
      # };

      #certificatesResolvers = {
      #  cloudflare = {
      #    acme = {
      #      email = "${config.vars.email}";
      #      storage = "/var/lib/traefik/acme.json";
      #      dnsChallenge = {
      #        provider = "cloudflare";
      #        # delayBeforeCheck = "5s";
      #        resolvers = [ "1.1.1.1:53" ];
      #      };
      #    };
      #  };
      #};
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          traefik = {
            entryPoints = ["https"];
            rule = "Host(`traefik.${baseDomain}`)";
            middlewares = ["authentik"];
            service = "api@internal";
          };
          k3s = {
            priority = 1; # lowest priority
            entryPoints = ["https"];
            rule = "HostRegexp(`{host:.+}`)";
            service = "k3s@file";
          };
        };

        middlewares = {
          whitelist = {
            ipWhiteList = {
              # ipStrategy.depth = 2;
              sourceRange = [
                "127.0.0.1"
                "192.168.1.1"
                "192.168.1.2"
                # "65.32.55.119"
              ];
            };
          };
        };

        services = {
          k3s = {
            loadBalancer = {
              servers = [
                {url = "http://127.0.0.1:9998";}
              ];
            };
          };
        };
      };

      tls = {
        stores = {
          default = {
            defaultGeneratedCert = {
              #resolver = "cloudflare";
              domain = {
                main = "*.${baseDomain}";
                # sans = [ "*.${baseDomain}" ];
              };
            };
          };
        };
      };
    };
  };
}
