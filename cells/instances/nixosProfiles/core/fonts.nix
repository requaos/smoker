{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    (nerdfonts.override {
      fonts = [
        "Hack"
        "Iosevka"
        "RobotoMono"
        "JetBrainsMono"
        "DejaVuSansMono"
      ];
    })
  ];

  fontconfig.defaultFonts = {
    monospace = ["DejaVuSansM Nerd Font Mono"];
    sansSerif = ["Hack Nerd Font"];
  };
}
