{
  inputs,
  cell,
}: {
  initrd.kernelModules = [
    "vfio_pci"
  ];
}
