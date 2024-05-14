{
  inputs,
  cell,
}: {
  displayManager = {
    defaultSession = "none+awesome";
    autoLogin = {
      user = "nixos";
      enable = true;
    };
  };
  xserver.displayManager.lightdm = {
    greeter.enable = false;
    autoLogin.timeout = 0;
    enable = true;
  };
  tumbler.enable = true;
  gvfs.enable = true;
}
