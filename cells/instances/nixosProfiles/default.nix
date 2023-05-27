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
  sound = load ./sound;
  users = load ./users;
  cachix = load ./cachix;
  display = load ./display;
  greeter = load ./greeter;
  utilities = load ./utilities;
}
