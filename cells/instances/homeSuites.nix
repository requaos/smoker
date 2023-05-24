{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    direnv
  ];

  req = base;

  nixos = base;
}
