{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    platform
    direnv
    git
  ];

  gui = with homeProfiles;
    [
      display.common
      display.xserver
      display.sway
      display.i3
      display.i3status
    ]
    ++ base;

  req = with homeProfiles;
    [
      development
    ]
    ++ gui;

  nixos = base;
}
