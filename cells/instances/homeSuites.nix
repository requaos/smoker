{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    cachix
    platform
    direnv
    git
  ];

  req = with homeProfiles;
    [
      coredns
    ]
    ++ base;

  nixos = base;
}
