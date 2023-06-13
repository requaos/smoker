{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [
    # fprintd-tod == fprintd /w (T)ouch (O)EM (D)rivers
    fprintd-tod
  ];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = nixpkgs.libfprint-2-tod1-goodix;
    };
  };

  security.pam.services = {
    login.fprintAuth = true;
    xscreensaver.fprintAuth = true;
  };
}
