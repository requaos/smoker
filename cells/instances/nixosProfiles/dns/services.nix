{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  coredns = {
    enable = true;
  };
}
