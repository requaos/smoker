{
  inputs,
  cell,
}: let
  themeName = "circuit";
in {
  initrd = {
    systemd = {
      enable = true;
    };
  };
  kernelParams = [
    "quiet"
  ];
  plymouth = {
    enable = true;
    theme = themeName;
    themePackages = [
      (inputs.nixpkgs.adi1090x-plymouth-themes.override {
        selected_themes = [
          themeName
        ];
      })
    ];
  };
}
