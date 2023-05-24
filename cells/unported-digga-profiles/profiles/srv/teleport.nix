{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = config.vars.domain;
  email = config.vars.email;
in {
  environment.systemPackages = with pkgs; [teleport];

  services.teleport = {
    enable = false;
    # diag = {
    #   enable = false;
    #   port = 3000;
    # };
    settings = {
      version = "v3";
      teleport = {
        nodename = "desktop";
        data_dir = "/volumes/teleport";
        log = {
          severity = "DEBUG";
          # output = "stderr";
          # format.output = "text";
        };
        ca_pin = "";
        diag_addr = "";
      };
      auth_service = {
        enabled = true;
        listen_addr = "0.0.0.0:3025";
        cluster_name = "teleport.${domain}";
        proxy_listener_mode = "multiplex";
      };
      proxy_service = {
        enabled = true;
        web_listen_addr = "0.0.0.0:3024";
        public_addr = "teleport.${domain}:443";
        https_keypairs = [];
        acme = {
          enabled = true;
          email = "${email}";
        };
      };
      app_service = {
        enabled = true;
        apps = [
          {
            name = "plex";
            uri = "http://127.0.0.1:32400";
            public_addr = "plex.teleport.${domain}";
          }
          {
            name = "demo";
            uri = "https://localhost.tably.com:8443";
            public_addr = "tably.teleport.${domain}";
          }
        ];
      };
      ssh_service = {
        enabled = false;
        # labels = {
        #   role = "client";
        # };
      };
    };
  };
}
