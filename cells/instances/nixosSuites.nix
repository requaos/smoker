{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base =
      [inputs.cells.system.nixosSuites.overrides]
      ++ [
        core
        cachix
        ssh
        dns

        users-root
      ];

    linuxapps =
      base
      ++ [
        linux
        sound
        greeter
        utilities-nethogs
        utilities-docker
        utilities-tio
      ];

    gui = [
      display-xserver
      display-signal
      display-sway
      display-i3
    ];

    home-printers = [
      devices-lexmarkC3224dw
    ];

    babybox =
      linuxapps
      ++ home-printers
      ++ gui
      ++ [
        pretty-boot

        devices-bluetooth
        devices-cdburn

        utilities-libvirtd
        utilities-fwupd

        users-req
      ];

    teeniebox =
      linuxapps
      ++ home-printers
      ++ gui
      ++ [
        pretty-boot

        devices-thunderbolt
        devices-bluetooth
        devices-fingerprint
        devices-cdburn

        utilities-libvirtd
        utilities-fwupd

        communication-slack

        users-req
      ];

    buukobox =
      linuxapps
      ++ home-printers
      ++ gui
      ++ [
        pretty-boot

        devices-android
        devices-thunderbolt
        devices-bluetooth
        devices-fingerprint
        devices-cdburn

        utilities-libvirtd
        utilities-fwupd

        display-nvidia

        communication-slack
        communication-zoom

        # development-java
        # development-cody
        development-rust

        corporate-vpn

        games

        users-req
      ];

    nixvmbox =
      linuxapps
      ++ gui
      ++ [
        users-req
      ];
  }
