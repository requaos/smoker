{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  # Getting access to mkLiteral through the cell inputs structure
  # was a pita, leaving here in-case I need it again:
  inherit (inputs.home-manager.lib.homeManagerConfiguration.lib.formats.rasi) mkLiteral;
in {
  rofi = {
    enable = true;
    terminal = "${nixpkgs.alacritty}/bin/alacritty";
    # Gonna match i3wn iconic appeal
    theme = /etc/rofi/theme.rasi;
  };
}
