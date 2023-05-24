{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in
  cell.lib.rakeLeaves ../unported-digga-profiles/profiles
  // {
    users = load ./users;
  }
