{
  cell,
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;

  lexmark-c3224dw = with nixpkgs;
    stdenv.mkDerivation rec {
      pname = "lexmark-c3224dw";
      version = "main";

      src = ./.;

      installPhase = ''
        mkdir -p $out/share/cups/model/
        cp Lexmark_C3200_Series.ppd $out/share/cups/model/

        mkdir -p $out/lib/cups/filter/
        cp rerouteprintoption $out/lib/cups/filter/
        cp lib/CommandFileFilterG2 $out/lib/cups/filter/

        # (if the ppd also comes with executables you may need to also patch the executables)
        substituteInPlace $out/share/cups/model/Lexmark_C3200_Series.ppd \
          --replace "/usr/lib/cups/filter/" "$out/lib/cups/filter/"
      '';
    };
in {
  printing.drivers = [lexmark-c3224dw];
}
