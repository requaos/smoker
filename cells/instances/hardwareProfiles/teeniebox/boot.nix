{
  inputs,
  cell,
}: {
  # bleeding-edge kernel: inputs.nixpkgs.linuxPackages_testing
  kernelPackages = inputs.nixpkgs.linuxPackages_latest;

  extraModulePackages = with inputs.nixpkgs; [
    #linuxPackages_latest.ipu6-drivers
    (cell.lib.lowPrio linuxPackages_latest.ivsc-driver)
    linuxPackages_latest.v4l2loopback
  ];

  kernelModules = [
    "v4l2loopback"
    "kvm-intel"
  ];

  extraModprobeConfig = ''
    options kvm_intel nested=1
    options v4l2loopback exclusive_caps=1
  '';

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
      "v4l2loopback"
      "kvm-intel"
    ];
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
        };
      };
    };
  };

  plymouth = {
    extraConfig = ''
      DeviceScale=1.5
    '';
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
