{
  inputs,
  cell,
}: let
  # zuki-themes was removed from nixpkgs 2026-07-22 along with the GTK2
  # engine packages it referenced; vendored from the last packaged revision
  # (nixpkgs 6597b98^) with those dead deps dropped. The GTK3/4 themes that
  # zukitre-dark comes from build fine with just meson/sassc.
  zuki-themes =
    inputs.nixpkgs.callPackage
    ({
      lib,
      stdenv,
      fetchFromGitHub,
      meson,
      ninja,
      sassc,
      gdk-pixbuf,
      librsvg,
    }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "zuki-themes";
        version = "4.0";

        src = fetchFromGitHub {
          owner = "lassekongo83";
          repo = "zuki-themes";
          rev = "v${finalAttrs.version}";
          sha256 = "1q026wa8xgyb6f5k7pqpm5zav30dbnm3b8w59as3sh8rhfgpbf80";
        };

        nativeBuildInputs = [meson ninja sassc];

        buildInputs = [gdk-pixbuf librsvg];

        meta = {
          description = "Themes for GTK, gnome-shell and Xfce";
          homepage = "https://github.com/lassekongo83/zuki-themes";
          license = lib.licenses.gpl3Only;
          platforms = lib.platforms.linux;
        };
      }))
    {};
in {
  enable = true;
  iconTheme = {
    name = "elementary-Xfce-dark";
    package = inputs.nixpkgs.elementary-xfce-icon-theme;
  };
  theme = {
    name = "zukitre-dark";
    package = zuki-themes;
  };
  gtk3.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };
  gtk4.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };
}
