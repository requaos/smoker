{
  inputs,
  cell,
}: {
  # bleeding-edge kernel:
  kernelPackages = inputs.nixpkgs.linuxPackages_latest;

  initrd = {
    kernelModules = [
      "hv_vmbus"
      "hv_utils"
      "hv_storvsc"
      "hv_netvsc"
      "hv_balloon"
    ];
    availableKernelModules = [
      "sd_mod"
      "sr_mod"
      "dm_mod"
    ];
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
