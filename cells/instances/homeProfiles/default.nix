{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  cachix = load ./cachix;
  coredns = load ./coredns;
  git = load ./git;
  platform = load ./platform;
  direnv = load ./direnv;
}
