{
  inputs,
  cell,
}: {
  "/" = {
    device = "/dev/disk/by-uuid/33a1de74-fe6d-4466-be43-ce02816d1679";
    fsType = "btrfs";
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/FBA5-7197";
    fsType = "vfat";
  };
}
