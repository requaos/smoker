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
      intel-vaapi-driver
    ];
  };
}
