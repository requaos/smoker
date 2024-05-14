{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;

  mod = "Mod4";
  fonts = {
    names = ["Hack Nerd Font"];
    size = 12.0;
  };
in {
  enable = true;
  windowManager.awesome = {
    enable = true;
    luaModules = with nixpkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };
}
