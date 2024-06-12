{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  fprintd = {
    enable = true;
    package = nixpkgs.fprintd.overrideAttrs {
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:TestPamFprintd"
        "--no-suite"
        "fprintd:TestFprintdUtilsVerify"
        "--no-suite"
        "fprintd:FPrintdVirtualDeviceClaimedTest"
      ];
    };
  };
}
