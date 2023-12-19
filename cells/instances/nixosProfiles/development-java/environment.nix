{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    jdk17
    lombok
  ];
}
