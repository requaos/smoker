{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in
  {
    core = load ./core;
    users = load ./users;
    gpg = load ./gpg;
    cachix = load ./cachix;
    discord = load ./discord;
    fonts = load ./fonts;
  }