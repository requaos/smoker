{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [core cachix dns users.root];

    teeniebox =
      base
      ++ [users.req];
  }
