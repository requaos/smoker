{
  inputs,
  cell,
}: let
  ivsc-firmware = with inputs.nixpkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = "main";
        sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";
      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };
in {
  cpu.intel.updateMicrocode = true;
  enableAllFirmware = true;

  firmware = [
    inputs.nixpkgs.ipu6-camera-bins
    ivsc-firmware
  ];

  ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  opengl = {
    enable = true;
    # driSupport = true; # for wine with openGL
    driSupport32Bit = true; # for wine with openGL
    extraPackages = with inputs.nixpkgs; [
      intel-vaapi-driver
    ];
  };
}
