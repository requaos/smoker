{
  inputs,
  cell,
}: {
  # bleeding-edge kernel: kernelPackages = inputs.nixpkgs.linuxPackages_testing;
  # Latest release kernel:
  kernelPackages = inputs.nixpkgs.linuxPackages_latest;

  initrd = {
    availableKernelModules = [
      "sd_mod"
      "sr_mod"
      "dm_mod"
      "hv_vmbus"
      "hv_utils"
      "hv_storvsc"
      "hv_netvsc"
      "hv_balloon"
    ];
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
