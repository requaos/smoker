{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [
      core
      cachix
      ssh
      dns

      users.root
    ];

    linuxapps =
      base
      ++ [
        linux
        sound
        utilities.nethogs
        utilities.docker
        utilities.tio
      ];

    teeniebox =
      linuxapps
      ++ [
        display.xserver
        display.signal
        display.sway
        display.i3

        devices.thunderbolt
        devices.bluetooth
        devices.fingerprint

        utilities.libvirtd
        utilities.fwupd

        users.req
      ];

    buukobox =
      linuxapps
      ++ [
        display.xserver
        display.signal
        display.sway
        display.i3

        #display.nvidia

        devices.thunderbolt
        devices.bluetooth
        devices.fingerprint

        utilities.libvirtd
        utilities.fwupd

        communication.slack
        communication.zoom

        users.req
      ];

    nixvmbox =
      linuxapps
      ++ [
        display.xserver
        display.signal
        display.sway
        display.i3

        users.req
      ];
  }
