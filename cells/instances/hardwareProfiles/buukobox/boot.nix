{
  inputs,
  cell,
}: {
  # bleeding-edge kernel:
  kernelPackages = inputs.nixpkgs.linuxPackages_testing;

  # nested virtualization in qemu/kvm
  extraModprobeConfig = "options kvm_intel nested=1";

  # The touchpad in Dell 13" XPS 9320 confuses the 'psmouse'
  # module and causes excessive delay and potential freezing
  # on shutdown.
  #blacklistedKernelModules = ["psmouse"];

  # virtualization module
  kernelModules = ["kvm-intel"];

  # graphics fix from dell for 'iris' opengl support
  # kernelParams = [
    # "i915.force_probe=46a6"
  # ];

  initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
      "thunderbolt"
    ];
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
