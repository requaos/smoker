{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [
      cli.programs
      core.nixos
      dev.git
      srv.ssh

      vars
      users.root
    ];
    desktop = [
      dev.codium
      dev.programs
      dev.starship
      devices.bluetooth
      devices.fingerprint

      gui.dbus
      gui.discord
      gui.dunst
      gui.i3
      gui.i3status
      gui.programs
      gui.rofi
      gui.rustdesk
      gui.signal
      gui.sound
      gui.sway
      gui.xserver
      srv.docker
    ];

    teeniebox =
      base
      ++ [desktop];
  }
