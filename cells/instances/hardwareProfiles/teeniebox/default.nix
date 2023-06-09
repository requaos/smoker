{
  inputs,
  cell,
}: {
  i18n.defaultLocale = "en_US.utf8";

  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-intel
  ];

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
    fwupd = {
      enable = true;
    };
    thermald = {
      enable = true;
    };
    fstrim = {
      enable = true;
    };
  };
  environment = {
    variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
    systemPackages = with inputs.nixpkgs; [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-good
      gst_all_1.icamerasrc-ipu6ep

      mesa
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      virglrenderer
      xdg-desktop-portal-wlr
    ];
  };
  console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
