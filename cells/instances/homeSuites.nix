{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    shell.common
    git.common
    direnv
    xdg
  ];

  req = with homeProfiles;
    [
      git.req
    ]
    ++ base;

  nixos = base;
}
