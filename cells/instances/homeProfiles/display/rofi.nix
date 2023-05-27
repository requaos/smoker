{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  programs.rofi = {
    enable = true;
    terminal = "${nixpkgs.alacritty}/bin/alacritty";
    # theme = {};
  };
}
