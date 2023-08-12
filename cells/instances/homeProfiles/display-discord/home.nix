{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  packages = with nixpkgs; [
    discord
    betterdiscordctl
  ];
}
