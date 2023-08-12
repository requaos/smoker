{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  programs.java = {
    enable = true;
    package = nixpkgs.jetbrains.jdk;
  };
  environment.systemPackages = with inputs.nixpkgs; [
    jetbrains.jdk
    lombok
  ];
}
