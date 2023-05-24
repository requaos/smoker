{
  config,
  lib,
  pkgs,
  ...
}: {
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.xscreensaver.fprintAuth = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];
}
