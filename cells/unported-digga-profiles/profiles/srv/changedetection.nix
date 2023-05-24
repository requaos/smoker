{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  host = "changedetection.${config.vars.domain}";
  addr = "127.0.0.1";
  httpPort = 9097;
  seleniumPort = 4445;
  playwrightPort = 4446;

  volumePath = "/volumes/changedetection";
in {
  services.traefik.dynamicConfigOptions.http = {
    routers = {
      changedetection = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        service = "changedetection";
      };
    };
    # middlewares = {
    #   changedetection = {
    #     forwardAuth = {
    #       address = "http://${addr}:${toString httpPort}/api/verify";
    #       trustForwardHeader = true;
    #       authResponseHeaders = [
    #         "Remote-User"
    #         "Remote-Groups"
    #         "Remote-Email"
    #         "Remote-Name"
    #       ];
    #     };
    #   };
    # };
    services = {
      changedetection = {
        loadBalancer = {
          servers = [
            {
              url = "http://${addr}:${toString httpPort}";
            }
          ];
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    changedetection = {
      autoStart = true;
      image = "ghcr.io/dgtlmoon/changedetection.io";
      environment = {
        # PUID = 1000;
        # PGID = 1000;
        PORT = "5000";
        WEBDRIVER_URL = "http://${addr}:${toString seleniumPort}/wd/hub";
        PLAYWRIGHT_DRIVER_URL = "ws://${addr}:${toString playwrightPort}/?stealth=1&--disable-web-security=true";
        BASE_URL = "https://${host}";
        USE_X_SETTINGS = "1";
        HIDE_REFERER = "false";
      };
      volumes = [
        "${volumePath}:/datastore"
      ];
      ports = [
        "${addr}:${toString httpPort}:5000"
      ];
    };

    changedetection-selenium = {
      autoStart = true;
      image = "selenium/standalone-chrome-debug:3.141.59";
      environment = {
        VNC_NO_PASSWORD = "1";
        SCREEN_WIDTH = "1920";
        SCREEN_HEIGHT = "1024";
        SCREEN_DEPTH = "24";
      };
      volumes = [
        # Workaround to avoid the browser crashing inside a docker container
        # See https://github.com/SeleniumHQ/docker-selenium#quick-start
        "/dev/shm:/dev/shm"
      ];
      ports = [
        "${addr}:${toString seleniumPort}:4444"
        # "${addr}:${toString seleniumDebugPort}:7900"
      ];
    };

    changedetection-playwright = {
      autoStart = true;
      image = "browserless/chrome";
      environment = {
        SCREEN_WIDTH = "1920";
        SCREEN_HEIGHT = "1024";
        SCREEN_DEPTH = "16";
        ENABLE_DEBUGGER = "false";
        PREBOOT_CHROME = "true";
        CONNECTION_TIMEOUT = "300000";
        MAX_CONCURRENT_SESSIONS = "10";
        CHROME_REFRESH_TIME = "600000";
        DEFAULT_BLOCK_ADS = "true";
        DEFAULT_STEALTH = "true";
        # Ignore HTTPS errors, like for self-signed certs
        DEFAULT_IGNORE_HTTPS_ERRORS = "true";
      };
      ports = [
        "${addr}:${toString playwrightPort}:3000"
      ];
    };
  };
}
