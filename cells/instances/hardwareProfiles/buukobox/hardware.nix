{
  config,
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

  opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
