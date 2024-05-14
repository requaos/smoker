{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    # nix
    #std
    nix-diff
    # rnix-lsp
    nixpkgs-fmt
    alejandra
    treefmt

    # java
    #jetbrains.jdk

    # fonts
    powerline-fonts
  ];
}
