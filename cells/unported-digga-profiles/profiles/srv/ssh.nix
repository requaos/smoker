{
  config,
  lib,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };
}
