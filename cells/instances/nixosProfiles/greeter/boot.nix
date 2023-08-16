{
  inputs,
  cell,
}: {
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
    theme = "circuit";
    themePackages = [
      inputs.nixpkgs.adi1090x-plymouth-themes
    ];
  };
}
