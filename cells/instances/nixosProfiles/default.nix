{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in
  {
    core = load ./core;
    users = load ./users;
    greeter = load ./greeter;
  }
