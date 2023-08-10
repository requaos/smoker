{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.home-manager.lib.homeManagerConfiguration.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    terminal = "${nixpkgs.alacritty}/bin/alacritty";
    theme = {
      "@import" = "${nixpkgs.rofi-unwrapped}/share/rofi/themes/DarkBlue.rasi";
    };
  };
}
