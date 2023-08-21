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
      display-rustdesk
      display-discord
      display-espanso
      display-xserver
      display-common
      display-pidgin
      display-signal
      display-dunst
      display-rofi
      display-sway
      display-i3
    ]
    ++ base;

  thin = with homeProfiles;
    [
      development
    ]
    ++ gui;

  thick = with homeProfiles;
    [
      development-heavy-extensions
    ]
    ++ thin;

  nixos = base;
}
