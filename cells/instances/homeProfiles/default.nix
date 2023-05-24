{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  shell = load ./shell;
  git = load ./git;
  direnv = load ./direnv;
  xdg = {
    xdg.enable = true;
  };
}
