{
  inputs,
  cell,
}: {
  teeniebox = {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
    ];

    boot = {
      # bleeding-edge kernel:
      kernelPackages = inputs.nixpkgs.linuxPackages_testing;

      kernelModules = ["kvm-intel"];
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "vmd"
          "thunderbolt"
        ];
        luks.devices."root".device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
      };

      # used for cross-compiling for aarch64.
      # https://github.com/nix-community/nixos-generators#cross-compiling
      binfmt.emulatedSystems = ["aarch64-linux"];

      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 25;
        };
        efi = {
          canTouchEfiVariables = true;
        };
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/33a1de74-fe6d-4466-be43-ce02816d1679";
        fsType = "btrfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/FBA5-7197";
        fsType = "vfat";
      };
    };

    swapDevices = [{device = "/dev/disk/by-uuid/0ab38578-d63e-42de-b68e-a32acba18ab8";}];

    i18n.defaultLocale = "en_US.utf8";

    networking = {
      useDHCP = cell.lib.mkForce true;
      networkmanager = {
        enable = cell.lib.mkForce true;
      };
    };

    hardware = {
      opengl.enable = true;
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;
    };
  };
}
