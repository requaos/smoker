{
  inputs,
  cell,
}: {
  services.xserver = {
    videoDrivers = ["displaylink"];
  };
}
