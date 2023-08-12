{
  inputs,
  cell,
}:
with cell.lib; let
  inherit (inputs) nixpkgs;
in {
  libvirtd = {
    enable = true;
    qemu = {
      package = nixpkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (nixpkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };
  };

  spiceUSBRedirection.enable = true;

  docker = {
    autoPrune.enable = true;
  };
}
