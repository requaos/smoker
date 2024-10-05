{
  config,
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

  graphics = {
    enable = true;
    enable32Bit = true; # for wine with openGL
  };
}
