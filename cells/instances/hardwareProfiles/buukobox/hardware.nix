{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  nvidia.package = inputs.nixpkgs.linuxPackages_testing.nvidiaPackages.vulkan_beta;

  opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with inputs.nixpkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
