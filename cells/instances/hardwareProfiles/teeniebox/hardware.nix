{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  # Intel Webcam
  firmware = with inputs.nixpkgs; [
    ipu6ep-camera-bin
  ];
  ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  opengl = {
    enable = true;
    extraPackages = with inputs.nixpkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
