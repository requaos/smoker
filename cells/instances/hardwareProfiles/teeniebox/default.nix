{
  inputs,
  cell,
}: {
  i18n.defaultLocale = "en_US.utf8";

  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/33a1de74-fe6d-4466-be43-ce02816d1679";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FBA5-7197";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/0ab38578-d63e-42de-b68e-a32acba18ab8";}];

  # Display scaling
  services = {
    xserver = {
      videoDrivers = ["iris"];
      dpi = 192;
      displayManager.sessionCommands = ''
        ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        Xft.dpi: 192
        EOF
      '';
    };
  };
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
