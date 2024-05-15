{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs;
in {
  enable = true;
}
