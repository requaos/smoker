{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;

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
