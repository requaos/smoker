{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs.nerd-fonts; [
    hack
    iosevka
    roboto-mono
    jetbrains-mono
    dejavu-sans-mono
  ];

  fontconfig.defaultFonts = {
    monospace = ["DejaVuSansM Nerd Font Mono"];
    sansSerif = ["Hack Nerd Font"];
  };
}
