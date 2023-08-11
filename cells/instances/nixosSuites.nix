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
        greeter
        utilities.nethogs
        utilities.docker
        utilities.tio
      ];

    babybox =
      linuxapps
      ++ [
        display.xserver
        display.signal
        display.sway
        display.i3

        devices.bluetooth
        devices.cdburn

        utilities.libvirtd
        utilities.fwupd

        users.req
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

        communication.slack

        users.req
      ];

    buukobox =
      linuxapps
      ++ [
        display.xserver
        display.signal
        display.sway
        display.i3

        devices.thunderbolt
        devices.bluetooth
        devices.fingerprint
        devices.cdburn

        utilities.libvirtd
        utilities.fwupd

        display.nvidia
        display.displaylink

        communication.slack
        communication.zoom

        development.java

        display.lutris

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
