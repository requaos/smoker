{
  inputs,
  cell,
}: {
  xidlehook = {
    enable = true;
    detect-sleep = true;
    not-when-fullscreen = true;
    # These timings are relative to one another,
    # such that an additional timer here of 10
    # seconds would be triggered 10 seconds
    # After the 600 second trigger has already
    # fired. Seems useful for if I wanted to
    # trigger the blurred background screengrab
    # a few seconds before actually locking for
    # a snappy experience.
    timers = [
      {
        delay = 600;
        command = "exec ${inputs.nixpkgs.betterlockscreen}/bin/betterlockscreen --lock --off 5";
      }
    ];
  };
  clipmenu = {
    enable = true;
  };
  # TODO: compton?
  picom.enable = true;
}
