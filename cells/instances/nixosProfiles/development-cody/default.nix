{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  cody-deb = inputs.nixpkgs.stdenv.mkDerivation {
    name = "cody-deb";
    builder = ./builder.sh;
    dpkg = inputs.nixpkgs.dpkg;
    src = inputs.nixpkgs.fetchurl {
      url = "https://github.com/sourcegraph/sourcegraph/releases/download/app-v2023.7.11%2B1384.7d20a90ce7/cody_2023.7.11+1384.7d20a90ce7_amd64.deb";
      hash = "sha256-qrqE0/dDe5mI8sYPlESOu/we7Kk7UKoQtSQ0vToPYyk=";
    };
  };
  cody = inputs.nixpkgs.buildFHSUserEnv {
    name = "cody";
    targetPkgs = pkgs: [cody-deb];
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
in {
  environment.systemPackages = [
    cody
  ];
}
