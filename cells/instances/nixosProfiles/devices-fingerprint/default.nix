{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  services.fprintd = {
    enable = true;
  };

  security.pam.services = {
    login.fprintAuth = true;
    xscreensaver.fprintAuth = true;
    swaylock.fprintAuth = true;
  };
}
