{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  displayManager = {
    defaultSession = "xfce";
    autoLogin = {
      user = "nixos";
      enable = true;
    };
  };
  xserver = {
    desktopManager = {
      xfce = {
        enable = true;
	enableScreensaver = false;
      };
    };
    displayManager = {
      lightdm = {
        greeter.enable = false;
        autoLogin.timeout = 0;
        enable = true;
      };
    };
  };
  tumbler.enable = true;
  gvfs.enable = true;
}
