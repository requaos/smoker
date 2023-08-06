{
  inputs,
  cell,
}: {
  # bleeding-edge kernel: inputs.nixpkgs.linuxPackages_testing
  kernelPackages = inputs.nixpkgs.linuxPackages_latest;

  # nested virtualization in qemu/kvm
  extraModprobeConfig = "options kvm_intel nested=1";
  
  kernelModules = [ "kvm-intel" ];

  initrd = {
    availableKernelModules = [
      "ahci" 
      "xhci_pci" 
      "usbhid" 
      "usb_storage" 
      "sd_mod" 
      "sdhci_acpi" 
      "rtsx_pci_sdmmc"
    ];
  };

  # used for cross-compiling for aarch64.
  # https://github.com/nix-community/nixos-generators#cross-compiling
  binfmt.emulatedSystems = ["aarch64-linux"];
}
