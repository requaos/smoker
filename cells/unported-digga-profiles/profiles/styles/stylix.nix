{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  base16-schemes = inputs.base16-schemes;
in {
  # stylix binary-cache: https://github.com/danth/stylix#binary-cache
  # nix = {
  #   settings = {
  #     substituters = [ "https://danth.cachix.org" ];
  #     trusted-public-keys = [ "danth.cachix.org-1:wpodfSL7suXRc/rJDZZUptMa1t4MJ795hemRN0q84vI=" ];
  #   };
  # };

  # stylix.autoEnable = false;
  # stylix.targets.alacritty.enable = true;
  stylix.targets.console.enable = false;
  # stylix.targets.dunst.enable = true;
  stylix.targets.gtk.enable = false;
  # stylix.targets.lightdm.enable = true;
  # stylix.targets.swaylock.enable = false;
  stylix.targets.vscode.enable = false;
  # stylix.polarity = "dark";
  # stylix.base16Scheme = "${base16-schemes}/material-darker.yaml";
  # stylix.base16Scheme = "${base16-schemes}/classic-dark.yaml";
  stylix.base16Scheme = "${base16-schemes}/onedark.yaml";
  # stylix.image = (toString ../../assets/wallpapers/jwst-cosmic-cliffs.png);
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  stylix.fonts = rec {
    serif = monospace;
    sansSerif = monospace;
    monospace = {
      package = pkgs.hack-font;
      name = "Hack";
    };
    # emoji = {
    #   package = pkgs.noto-fonts-emoji;
    #   name = "Noto Color Emoji";
    # };
  };
}
