{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  direnv = load ./direnv;
}
