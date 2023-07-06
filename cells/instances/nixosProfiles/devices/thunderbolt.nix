{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  services.hardware.bolt.enable = true;
  environment.systemPackages = with nixpkgs; [
    bolt
  ];
}
