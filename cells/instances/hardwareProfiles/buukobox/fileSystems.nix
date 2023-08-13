{
  inputs,
  cell,
}: {
  "/" = {
    device = "/dev/disk/by-uuid/ffae4d62-edb8-41a5-ade9-dd371490ebd8";
    fsType = "btrfs";
    options = ["subvol=@"];
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/EA31-5359";
    fsType = "vfat";
  };
}
