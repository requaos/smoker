{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  t = nixpkgs.stdenv.mkDerivation {
    name = "starship-nushell-init";
    buildInputs = with nixpkgs; [
      nushell
      starship
    ];
    unpackPhase = ":";
    buildPhase = ''
      starship init nu > ./starship_init.nu
    '';
    installPhase = ''
      install -m755 -D ./starship_init.nu $out/bin/init.nu
    '';
  };
in {
  file = {
    ".cache/starship/init.nu" = {
      source = "${t}/bin/init.nu";
      force = true;
    };
  };
  packages = with nixpkgs; [
    # nix
    #std
    nix-diff
    # rnix-lsp
    nixpkgs-fmt
    alejandra
    treefmt
    nufmt

    # java
    #jetbrains.jdk

    # fonts
    powerline-fonts
  ];
}
