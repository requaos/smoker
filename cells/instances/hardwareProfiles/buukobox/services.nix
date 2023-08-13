{
  inputs,
  cell,
}: {
  xserver = {
    # host-based hardwareProfile is the appropriate place to set drivers.
    videoDrivers = [
      "nvidia"
      "displaylink"
      "modesetting"
    ];
    dpi = 192;
    displayManager.sessionCommands = ''
      ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 192
      EOF
    '';
  };
  udev = {
    extraRules = ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${inputs.nixpkgs.autorandr}/bin/autorandr -c"'';
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
