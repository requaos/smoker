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
  loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 25;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
  plymouth = {
    enable = true;
    theme = "abstract_ring";
    themePackages = [
      inputs.nixpkgs.adi1090x-plymouth-themes
    ];
  };
}
