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
        cp cupsversion $out/lib/cups/filter/
        cp fax-pnh-filter $out/lib/cups/filter/
        cp LexHBPFilter $out/lib/cups/filter/
        cp CommandFileFilterG2 $out/lib/cups/filter/

        # (if the ppd also comes with executables you may need to also patch the executables)
        substituteInPlace $out/share/cups/model/Lexmark_C3200_Series.ppd \
          --replace "/usr/lib/cups/filter/" "$out/lib/cups/filter/"

        substituteInPlace $out/lib/cups/filter/rerouteprintoption \
          --replace "/usr/bin/perl" "${perl}/bin/perl"

        substituteInPlace $out/lib/cups/filter/fax-pnh-filter \
          --replace "/bin/sh" "${bash}/bin/sh" \
          --replace "/bin/echo" "${uutils-coreutils-noprefix}/bin/echo" \
          --replace "/bin/sed" "${gnused}/bin/sed" \
          --replace "/bin/hostname" "${uutils-coreutils-noprefix}/bin/hostname" \
          --replace "/bin/awk" "${gawk}/bin/awk"
      '';
      preFixup = ''
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/lib/cups/filter/cupsversion
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/lib/cups/filter/LexHBPFilter
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/lib/cups/filter/CommandFileFilterG2
      '';
    };
in {
  printing.drivers = [lexmark-c3224dw];
}
