{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  environment = {
    systemPackages = with nixpkgs; [
      virt-manager
    ];
  };

  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemu = {
      package = nixpkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        package = nixpkgs.OVMFFull.override {
          secureBoot = true;
          tpmSupport = true;
        };
      };
    };

    docker = {
      autoPrune.enable = true;
    };
  };
}
