{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
        nerdfonts
        hack-font
        dejavu_fonts
        roboto
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono for Powerline" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };
  };
}