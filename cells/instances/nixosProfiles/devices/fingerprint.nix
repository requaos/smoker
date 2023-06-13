{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [
    fprintd
  ];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = nixpkgs.libfprint-2-tod1-goodix;
    };
  };
}
