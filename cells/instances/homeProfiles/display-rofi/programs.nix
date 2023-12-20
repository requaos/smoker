{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  rofi = {
    enable = true;
    terminal = "${nixpkgs.alacritty}/bin/alacritty";

    theme = ./theme.rasi;
  };
}
