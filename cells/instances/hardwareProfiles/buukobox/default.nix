{
  inputs,
  cell,
}: {
  i18n.defaultLocale = "en_US.utf8";

  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
  ];

  # Display scaling and drivers
  services = {
    xserver = {
      # host-based hardwareProfile is the appropriate place to set drivers.
      videoDrivers = [
        "nvidia"
        "displaylink"
      ];
      dpi = 192;
      displayManager.sessionCommands = ''
        ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        Xft.dpi: 192
        EOF
      '';
    };
    udev = {
      extraRules = ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${inputs.nixpkgs.autorandr}/bin/autorandr -c"'';
    };
  };
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
