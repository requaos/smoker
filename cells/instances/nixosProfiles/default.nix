{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  dns = load ./dns;
  core = load ./core;
  users = load ./users;
  cachix = load ./cachix;
  greeter = load ./greeter;
}
