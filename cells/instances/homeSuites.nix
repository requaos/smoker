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

  req = with homeProfiles;
    [
      development
    ]
    ++ base;

  nixos = base;
}
