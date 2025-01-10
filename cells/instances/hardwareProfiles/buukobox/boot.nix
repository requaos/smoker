{
  inputs,
  cell,
}: {
  # bleeding-edge kernel:
  # kernelPackages = inputs.nixpkgs.linuxPackages_latest;
  # defaults to stable kernel when unset

  # nested virtualization in qemu/kvm
  extraModprobeConfig = "options kvm_intel nested=1";

  # virtualization module
  kernelModules = ["kvm-intel"];

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

    # acpi_backlight=none allows the backlight save/load systemd service to work.
    # "acpi_backlight=none"
    "acpi_osi=Linux"

    # #isolate the GPU
    # ("vfio-pci.ids="
    # + cell.lib.concatStringsSep "," [
    # "10de:2438" # Graphics
    # "10de:2288" # Audio
    # ])
  ];

  # Fancy Boot
  plymouth = {
    extraConfig = ''
      DeviceScale=4
    '';
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
