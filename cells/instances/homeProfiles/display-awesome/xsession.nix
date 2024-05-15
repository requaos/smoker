{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs;
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
