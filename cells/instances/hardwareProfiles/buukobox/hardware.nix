{ inputs
, cell
,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  nvidia.package = inputs.nixpkgs.linuxPackages_6_5.nvidiaPackages.vulkan_beta;

  opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
