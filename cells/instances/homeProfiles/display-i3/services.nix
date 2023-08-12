{
  inputs,
  cell,
}: {
  betterlockscreen = {
    enable = true;
    arguments = ["--off" "5"];
    # inactiveInterval = 10;
  };
  clipmenu = {
    enable = true;
  };
  # TODO: compton?
  picom.enable = true;
}
