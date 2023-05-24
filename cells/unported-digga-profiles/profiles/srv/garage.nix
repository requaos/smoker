{
  config,
  lib,
  pkgs,
  ...
}: let
  l = builtins // pkgs.lib;

  # this is `garage_0_7` by default in `services.garage.pakcage`!?!
  package = pkgs.garage;

  apiHost = "s3.${config.vars.domain}";
  apiAddr = "127.0.0.1";
  apiPort = 3900;
  webHost = "web.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 3902;
  adminHost = "garage.${config.vars.domain}";
  adminAddr = "127.0.0.1";
  adminPort = 3903;
  k2vAddr = "127.0.0.1";
  k2vPort = 3904;
  # volumePath = "/volumes/garage";
in {
  # install the package as well for cli usage
  environment.systemPackages = [package];

  # hack to try to fix `volumePath` permissions
  # systemd.services.garage.serviceConfig = {
  #   StateDirectory = l.mkForce "/volumes";
  #   StateDirectoryMode = "0770";
  #   User = "garage";
  #   Group = "garage";
  # };
  # systemd.tmpfiles.rules = [
  #   "d ${volumePath} 0770 garage garage"
  # ];

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      garage-api = {
        entryPoints = ["https"];
        rule = "Host(`${apiHost}`)";
        service = "garage-api";
      };
      garage-web = {
        entryPoints = ["https"];
        rule = "Host(`${webHost}`)";
        service = "garage-web";
      };
      # garage-k2v = {
      #   entryPoints = [ "https" ];
      #   rule = "Host(`${k2vHost}`)";
      #   service = "garage-k2v";
      # };
      garage-admin = {
        entryPoints = ["https"];
        rule = "Host(`${adminHost}`)";
        service = "garage-admin";
      };
    };
    services = {
      garage-api = {
        loadBalancer = {
          servers = [
            {
              url = "http://${apiAddr}:${toString apiPort}";
            }
          ];
        };
      };
      garage-web = {
        loadBalancer = {
          servers = [
            {
              url = "http://${webAddr}:${toString webPort}";
            }
          ];
        };
      };
      # garage-k2v = {
      #   loadBalancer = {
      #     servers = [{
      #       url = "http://${k2vAddr}:${toString k2vPort}";
      #     }];
      #   };
      # };
      garage-admin = {
        loadBalancer = {
          servers = [
            {
              url = "http://${adminAddr}:${toString adminPort}";
            }
          ];
        };
      };
    };
  };

  services.garage = {
    inherit package;
    enable = true;
    logLevel = "info"; # debug
    settings = {
      # metadata_dir = "${volumePath}/meta";
      # data_dir = "${volumePath}/data";

      db_engine = "lmdb";
      # block_size = 1048576;
      replication_mode = "none"; # 1
      # compression_level = 1;

      rpc_bind_addr = "127.0.0.1:3901";
      rpc_public_addr = "127.0.0.1:3901";
      # TODO: prevent this from getting written to the nix store
      # used `openssl rand -hex 32` to generate:
      rpc_secret = "f6af68aedc6e1f96a8993f5a7f75febc6c39fef51467e0f9e9fbdaa1f4e43626";

      s3_api = {
        s3_region = "us-beast-1";
        api_bind_addr = "${apiAddr}:${toString apiPort}";
        root_domain = ".${apiHost}";
      };

      s3_web = {
        bind_addr = "${webAddr}:${toString webPort}";
        root_domain = ".${webHost}";
        index = "index.html";
      };

      k2v_api = {
        api_bind_addr = "${k2vAddr}:${toString k2vPort}";
      };

      admin = {
        api_bind_addr = "${adminAddr}:${toString adminPort}";
        # used `openssl rand -base64 32` to generate:
        admin_token = "lI+rt+VeqFwruQl2Ovdxxe0nRPs8HlzYt8HAlF/MQ3U=";
      };
    };
  };
}
