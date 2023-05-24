{
  inputs,
  cell,
}: let
  defaults = {
    hardware.opengl.enable = true;
    hardware.enableRedistributableFirmware = true;
  };
in {
  teeniebox = {
    imports = with inputs.nixos-hardware.nixosModules; [
      defaults
      common-cpu-intel
    ];

    boot = {
      kernelModules = ["kvm-intel"];
      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "vmd"
        "thunderbolt"
      ];
    };
  };

#   autolycus = {
#     imports = with inputs.nixos-hardware.nixosModules; [
#       defaults
#       lenovo-thinkpad-t420
#     ];

#     boot.initrd.availableKernelModules = []; # TODO
#   };
}