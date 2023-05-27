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
        utilities.nethogs
      ];

    teeniebox =
      linuxapps
      ++ [
        display.xserver
        display.sway
        display.i3

        users.req
      ];
  }
