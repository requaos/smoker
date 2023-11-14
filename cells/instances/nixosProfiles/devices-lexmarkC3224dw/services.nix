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

      nativeBuildInputs = [makeWrapper];
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

        patchShebangs $out/lib/cups/filter/rerouteprintoption
        patchShebangs $out/lib/cups/filter/fax-pnh-filter

        substituteInPlace $out/lib/cups/filter/fax-pnh-filter \
          --replace "/bin/echo" "${uutils-coreutils-noprefix}/bin/echo" \
          --replace "/bin/sed" "${gnused}/bin/sed" \
          --replace "/bin/hostname" "${uutils-coreutils-noprefix}/bin/hostname" \
          --replace "/bin/awk" "${gawk}/bin/awk"
      '';
      preFixup = ''
        wrapProgram $out/lib/cups/filter/rerouteprintoption \
          --prefix PATH ":" ${lib.makeBinPath [perl bash gnused gawk uutils-coreutils-noprefix]}
        wrapProgram $out/lib/cups/filter/fax-pnh-filter \
          --prefix PATH ":" ${lib.makeBinPath [bash gnused gawk uutils-coreutils-noprefix]}

        patchelf \
          --set-interpreter ${glibc.out}/lib/ld-linux.so.2 \
          $out/lib/cups/filter/cupsversion
        wrapProgram $out/lib/cups/filter/cupsversion \
          --prefix PATH ":" ${lib.makeBinPath [bash gnused uutils-coreutils-noprefix]}

        patchelf \
          --set-interpreter ${glibc.out}/lib/ld-linux.so.2 \
          $out/lib/cups/filter/LexHBPFilter
        wrapProgram $out/lib/cups/filter/LexHBPFilter \
          --prefix PATH ":" ${lib.makeBinPath [ghostscript a2ps file gnused gawk uutils-coreutils-noprefix]}

        patchelf \
          --set-interpreter ${glibc.out}/lib/ld-linux.so.2 \
          $out/lib/cups/filter/CommandFileFilterG2
        wrapProgram $out/lib/cups/filter/CommandFileFilterG2 \
          --prefix PATH ":" ${lib.makeBinPath [ghostscript a2ps file gnused gawk uutils-coreutils-noprefix]}
      '';
    };
in {
  printing.drivers = [lexmark-c3224dw];
}
