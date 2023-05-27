{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  git = load ./git;
  platform = load ./platform;
  direnv = load ./direnv;
  development = load ./development;
}
