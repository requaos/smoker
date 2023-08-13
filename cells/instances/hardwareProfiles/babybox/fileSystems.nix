{
  inputs,
  cell,
}: {
  "/" = {
    device = "/dev/disk/by-uuid/0d67162c-bc3d-45b6-a4a5-cd65c2d088b1";
    fsType = "btrfs";
    options = ["subvol=@"];
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/F984-617C";
    fsType = "vfat";
  };
}
