{
  config,
  lib,
  pkgs,
  ...
}: let
  host = "home.${config.vars.domain}";
  alias = "home-assistant.${config.vars.domain}";
  webAddr = "127.0.0.1";
  webPort = 8123;
  volumePath = "/volumes/iot/home-assistant";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      home-assistant = {
        entryPoints = ["https"];
        rule = "Host(`${host}`, `${alias}`)";
        service = "home-assistant";
      };
    };
    services = {
      home-assistant = {
        loadBalancer = {
          servers = [
            {
              url = "http://${webAddr}:${toString webPort}";
            }
          ];
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["hass"];
    ensureUsers = [
      {
        name = "hass";
        ensurePermissions = {"DATABASE hass" = "ALL PRIVILEGES";};
      }
    ];
  };

  services.home-assistant = {
    enable = true;
    extraPackages = python3Packages:
      with python3Packages; [
        # postgresql support
        psycopg2
      ];

    configDir = volumePath;
    extraComponents = [
      "default_config"
      "mobile_app"
      "met"
      "radio_browser"
      "august"
      "xiaomi_ble"
      "zha"
      "zwave_js"
      "ibeacon"
      "wake_on_lan"
      "notion"
      # "google"
      "cast"
      "esphome"
      "octoprint"
      "discord"
      "jellyfin"
      "webostv"
      "radarr"
      "sonarr"
      "sabnzbd"
    ];
    # extraPackages = [];
    # openFirewall = true;

    # configWritable = true;
    config = {
      homeassistant = {
        name = "Home";
        # latitude = "!secret latitude";
        # longitude = "!secret longitude";
        # elevation = "!secret elevation";
        unit_system = "metric";
        currency = "USD";
        country = "US";
        time_zone = "America/New_York";
        # internal_url = "https://${webAddr}:${toString webPort}";
        internal_url = "https://${host}";
        external_url = "https://${host}";
      };
      recorder = {
        # db_url = "!secret db_url";
        db_url = "postgresql://@/hass";
      };
      http = {
        server_host = webAddr;
        server_port = webPort;
        trusted_proxies = [webAddr];
        use_x_forwarded_for = true;
      };
      frontend = {
        themes = "!include_dir_merge_named themes";
      };
      mobile_app = {};
      # feedreader.urls = [
      #   "https://nixos.org/blogs.xml"
      # ];
    };

    # lovelaceConfigWritable = true;
    # lovelaceConfig = { };
  };
}
