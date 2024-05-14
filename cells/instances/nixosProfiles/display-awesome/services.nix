{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  displayManager = {
    defaultSession = "none+awesome";
    autoLogin = {
      user = "nixos";
      enable = true;
    };
  };
  xserver = {
    windowManager.awesome = {
      enable = true;
      luaModules = with nixpkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
    displayManager = {
      lightdm = {
        greeter.enable = false;
        autoLogin.timeout = 0;
        enable = true;
      };
      # We may need to manually create a session:
      # session = [
      #   {
      #     name = "i3";
      #     manage = "desktop";
      #     start = ''exec $HOME/.xsession'';
      #   }
      # ];
    };
  };
  tumbler.enable = true;
  gvfs.enable = true;
}
