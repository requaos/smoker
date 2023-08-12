{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  java = {
    enable = true;
    package = nixpkgs.jetbrains.jdk;
  };
}
