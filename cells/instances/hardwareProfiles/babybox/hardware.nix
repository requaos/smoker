{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableRedistributableFirmware = true;

  opengl = {
    enable = true;
    driSupport = true; # for wine with openGL
    driSupport32Bit = true; # for wine with openGL
  };
}
