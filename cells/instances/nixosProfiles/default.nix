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
  devices = load ./devices;
  display = load ./display;
  greeter = load ./greeter;
  utilities = load ./utilities;
  development = load ./development;
  communication = load ./communication;
}
