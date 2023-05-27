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
      #kernelPackages = inputs.nixpkgs.linuxPackages_testing;

      kernelModules = ["kvm-intel"];
      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "vmd"
        "thunderbolt"
      ];
    };

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
