{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
  ];

  fontconfig.defaultFonts = {
    monospace = ["DejaVuSansM Nerd Font Mono"];
    sansSerif = ["Hack Nerd Font"];
  };
}
