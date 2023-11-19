{
  inputs,
  cell,
}: {
  xserver = {
    videoDrivers = ["iris"];
  };
  fwupd = {
    enable = true;
  };
  thermald = {
    enable = true;
  };
  fstrim = {
    enable = true;
  };
}
