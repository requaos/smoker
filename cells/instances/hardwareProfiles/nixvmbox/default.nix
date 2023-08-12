{
  inputs,
  cell,
}: {
  i18n.defaultLocale = "en_US.utf8";

  # This host lives in a hyper-v vm.
  virtualisation.hypervGuest.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/40ced919-440e-4aeb-8578-09ffc94621a0";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/CECC-FEF2";
      fsType = "vfat";
    };
  };

  # Display scaling
  services = {
    xserver = {
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
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
