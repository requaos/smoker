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

        devices.bluetooth
        devices.fingerprint

        utilities.libvirtd
        utilities.fwupd

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
