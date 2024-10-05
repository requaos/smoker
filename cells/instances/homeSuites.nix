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
      # display-rustdesk
      display-discord
      display-espanso
      display-xserver
      display-common
      display-pidgin
      display-signal
      display-social
      display-dunst
      display-rofi
      display-sway
      display-i3
    ]
    ++ base;

  thick = with homeProfiles;
    [
      development
      development-heavy-extensions
    ]
    ++ gui;

  thin = with homeProfiles;
    [
      display-xserver
      display-common
      display-dunst
      display-awesome
      development
    ]
    ++ base;

  nixos = base;
}
