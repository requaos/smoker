{
  inputs,
  cell,
}: {
  # bleeding-edge kernel:
  kernelPackages = inputs.nixpkgs.linuxPackages_6_5;

  # nested virtualization in qemu/kvm
  extraModprobeConfig = "options kvm_intel nested=1";

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

    # root disk encryption
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/0463b269-67b8-4fd2-a9d1-a60d244ef12e";
        };
      };
    };
  };

  # enable vfio
  kernelParams = [
    # enable IOMMU
    "intel_iommu=on"
    #"module_blacklist=i915" # in bios it's set to only use the nvidia gpu

    # #isolate the GPU
    # ("vfio-pci.ids="
    # + cell.lib.concatStringsSep "," [
    # "10de:2438" # Graphics
    # "10de:2288" # Audio
    # ])
  ];

  plymouth = {
    extraConfig = ''
      DeviceScale=2
    '';
  };

  # Quiet boot so that plymouth animations look sweet and seemless, disable or modify here for debugging hardware issues
  # 7 = Debug
  # 6 = Info
  # 5 = Notice
  # 4 = Warn
  # 3 = Err
  # 2 = Crit
  # 1 = Alert
  # 0 = Emerg
  consoleLogLevel = 1;

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
