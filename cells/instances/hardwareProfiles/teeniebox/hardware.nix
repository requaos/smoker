{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  # Intel Webcam
  firmware = with inputs.nixpkgs; [
    ivsc-firmware
  ];
  ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  inputs.nixpkgs.overlays = [
    (_: _: {
      # !!! overlay to force full deps on unstable opengl
      mesa = unstable.mesa;
      intel-media-driver = unstable.intel-media-driver;
      vaapiIntel = unstable.vaapiIntel;
      vaapiVdpau = unstable.vaapiVdpau;
      libvdpau-va-gl = unstable.libvdpau-va-gl;
      virglrenderer = unstable.virglrenderer;
      xdg-desktop-portal-wlr = unstable.xdg-desktop-portal-wlr;
      qemu = unstable.qemu;
    })
  ];

  opengl = {
    enable = true;
    driSupport = true; # for wine with openGL
    driSupport32Bit = true; # for wine with openGL
    extraPackages = with inputs.nixpkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
