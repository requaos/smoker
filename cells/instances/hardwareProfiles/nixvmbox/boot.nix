{
  inputs,
  cell,
}: {
  # bleeding-edge kernel:
  kernelPackages = inputs.nixpkgs.linuxPackages_testing;

  # virtualization module
  kernelModules = [];

  initrd = {
    availableKernelModules = [
      "sd_mod"
      "sr_mod"
    ];
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
