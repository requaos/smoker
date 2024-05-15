{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  displayManager = {
    defaultSession = "awesome";
    autoLogin = {
      user = "nixos";
      enable = true;
    };
  };
  xserver = {
    desktopManaer = {
      xfce = {
        enable = true;
      };
    };
    displayManager = {
      lightdm = {
        greeter.enable = false;
        autoLogin.timeout = 0;
        enable = true;
      };
      session = [
        {
          name = "awesome";
          manage = "desktop";
          start = ''exec $HOME/.xsession'';
        }
      ];
    };
  };
  tumbler.enable = true;
  gvfs.enable = true;
}
