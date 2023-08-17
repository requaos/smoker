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
    monospace = ["DejaVuSansMono"];
    sansSerif = ["Hack"];
  };
}
