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

    thin-client =
      base
      ++ [
        linux
        sound

        utilities-nethogs
        utilities-tio

        display-xserver
        display-awesome

        users-nixos
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
      thin-client
      ++ [
        pretty-boot

        devices-bluetooth
        devices-cdburn

        utilities-fwupd

        games-edu

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
        design

        srv-postgres
        srv-surrealdb
        srv-ollama
        srv-windmill

        communication-slack
        communication-zoom

        development-java
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
