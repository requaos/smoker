{ inputs
, cell
,
}:
let
  inherit (inputs) nixpkgs;
  cody-deb = inputs.nixpkgs.stdenv.mkDerivation {
    name = "cody-deb";
    builder = ./builder.sh;
    dpkg = inputs.nixpkgs.dpkg;
    src = inputs.nixpkgs.fetchurl {
      url = "https://github.com/sourcegraph/sourcegraph/releases/download/app-v2023.9.22%2B1398.91e4161d32/cody_2023.9.22+1398.91e4161d32_amd64.deb";
      hash = "sha256-nSr8hXOfeZDaiYPXsCaGVW9FJvKtIfSxZF1PXQA06pY=";
    };
  };
  cody = inputs.nixpkgs.buildFHSUserEnv {
    name = "cody";
    targetPkgs = pkgs: [ cody-deb ];
    multiPkgs = pkgs:
      with inputs.nixpkgs; [
        cairo
        gdk-pixbuf
        libsoup
        glib
        openssl_1_1
        libayatana-appindicator
        gtk3-x11
        webkitgtk
        dpkg
      ];
    extraBuildCommands = ''
      mkdir -p $out/usr/.bin
      cp $out/usr/bin/sourcegraph-backend $out/usr/.bin/sourcegraph-backend
    '';
    runScript = "cody";
  };
in
{
  environment.systemPackages = [
    cody
  ];
}
