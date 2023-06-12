{
  inputs,
  cell,
}: {
  fonts = with inputs.nixpkgs; [
    nerdfonts
    hack-font
    dejavu_fonts
    roboto
  ];

  fontconfig.defaultFonts = {
    monospace = ["DejaVu Sans Mono for Powerline"];
    sansSerif = ["DejaVu Sans"];
  };
}
