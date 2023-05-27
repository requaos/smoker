{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  cachix = load ./cachix;
  git = load ./git;
  platform = load ./platform;
  direnv = load ./direnv;
  development = load ./development;
}
