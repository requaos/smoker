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
    };
  };

  spiceUSBRedirection.enable = true;

  docker = {
    autoPrune.enable = true;
  };
}
