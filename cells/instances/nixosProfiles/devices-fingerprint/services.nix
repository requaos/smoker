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
        "fprintd:FPrintdVirtualDeviceStorageTest"
        "--no-suite"
        "fprintd:FPrintdVirtualDeviceStorageClaimedTest"
        "--no-suite"
        "fprintd:FPrintdVirtualDeviceNoStorageVerificationTests"
        "--no-suite"
        "fprintd:FPrintdVirtualDeviceStorageIdentificationTests"
        "--no-suite"
        "fprintd:FPrintdVirtualDeviceClaimedTest"
      ];
    };
  };
}
