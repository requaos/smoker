{
  inputs,
  cell,
}: {
  xserver = {
    enable = true;

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.clickMethod = "clickfinger";
    };

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";

    # https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
    # displayManager.startx.enable = true;

    # displayManager = {
    #   lightdm.enable = true;
    #   defaultSession = "xsession";
    #   session = [
    #     {
    #       manage = "desktop";
    #       name = "i3";
    #       start = ''exec $HOME/.xsession'';
    #     }
    #   ];
    # };
  };
}
