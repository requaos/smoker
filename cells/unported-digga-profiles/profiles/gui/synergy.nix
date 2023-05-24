{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.synergy-tls-cert = {
    file = ../../secrets/synergy-tls-cert.age;
    owner = config.vars.username;
    mode = "400";
  };

  environment.systemPackages = with pkgs; [
    synergy
  ];

  services.synergy.server = {
    enable = false;
    tls = {
      enable = true;
      cert = config.age.secrets.synergy-tls-cert.path;
    };
    configFile = pkgs.writeText "synergy-config" ''
      section: screens
        desktop:
        windows:
      end
      section: links
        desktop:
          right = windows
        windows:
          left = desktop
      end
    '';
  };

  networking.firewall.allowedTCPPorts = [
    24800
  ];
}
