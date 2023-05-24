{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in
  {
    git = load ./git;
    direnv = load ./direnv;
    xdg = {
        xdg.enable = true;
    };
  }