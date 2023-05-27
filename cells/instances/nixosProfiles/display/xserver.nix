{
  inputs,
  cell,
}: {
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
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

  # 96, 120 (25% higher), 144 (50% higher), 168 (75% higher), 192 (100% higher)
  # services.xserver.dpi = 144;
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  # };

  environment.systemPackages = with inputs.nixpkgs; [
    libnotify
    xterm
    xclip
    maim
    pciutils
    file

    gnumake
    gcc
  ];
}
