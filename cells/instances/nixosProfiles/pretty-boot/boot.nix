{
  inputs,
  cell,
}: let
  themeName = "circuit";
in {
  # Quiet boot so that plymouth animations look sweet and seemless, disable or modify here for debugging hardware issues
  # 7 = Debug
  # 6 = Info
  # 5 = Notice
  # 4 = Warn
  # 3 = Err
  # 2 = Crit
  # 1 = Alert
  # 0 = Emerg
  consoleLogLevel = 1;

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
