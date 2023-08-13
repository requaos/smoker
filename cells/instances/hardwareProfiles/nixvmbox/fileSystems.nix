{
  inputs,
  cell,
}: {
  "/" = {
    device = "/dev/disk/by-uuid/40ced919-440e-4aeb-8578-09ffc94621a0";
    fsType = "ext4";
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/CECC-FEF2";
    fsType = "vfat";
  };
}
