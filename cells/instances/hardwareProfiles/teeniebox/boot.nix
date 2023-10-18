{
  inputs,
  cell,
}: {
  # bleeding-edge kernel: inputs.nixpkgs.linuxPackages_testing
  kernelPackages = inputs.nixpkgs.linuxPackages_latest;

  # The touchpad in Dell 13" XPS Pro 9320 confuses the 'psmouse'
  # module and causes excessive delay and potential freezing
  # on shutdown.
  blacklistedKernelModules = ["psmouse"];

  # graphics fix from dell for 'iris' opengl support
  kernelParams = [
    "i915.force_probe=46a6"
  ];

  initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "vmd"
      "thunderbolt"
    ];
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
        };
      };
    };
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
