{
  inputs,
  cell,
}: {
  cpu.intel.updateMicrocode = true;
  enableAllFirmware = true;

  firmware = with inputs.nixpkgs; [
    ipu6-camera-bin
    ivsc-firmware
  ];

  # ipu6 = {
  #   enable = true;
  #   platform = "ipu6ep";
  # };

  opengl = {
    enable = true;
    driSupport = true; # for wine with openGL
    driSupport32Bit = true; # for wine with openGL
    extraPackages = with inputs.nixpkgs; [
      intel-vaapi-driver
    ];
  };
}
