{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    git.common
    direnv
    xdg
  ];

  req = with homeProfiles;
    [
      gpg
      git.req
      shell.nushell
    ]
    ++ base;

  nixos = base;
}