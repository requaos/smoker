{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  git = load ./git;
  direnv = load ./direnv;
  display = load ./display;
  platform = load ./platform;
  vscodext = load ./vscodext;
  development = load ./development;
}
