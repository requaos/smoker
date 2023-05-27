{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [core users.root];

    teeniebox =
      base
      ++ [users.req];
  }
