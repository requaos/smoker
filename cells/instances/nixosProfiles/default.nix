{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  dns = load ./dns;
  ssh = load ./ssh;
  core = load ./core;
  linux = load ./linux;
  users = load ./users;
  cachix = load ./cachix;
  greeter = load ./greeter;
}
