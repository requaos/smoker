{
  inputs,
  cell,
}: {
  xserver = {
    # cells shouldn't decide on drivers, these need to be defined in the hardwareProfile
    #videoDrivers = ["displaylink"];
  };
}
