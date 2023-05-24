{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [core cachix fonts gpg users.root];
    chat = [discord];
    pc =
      base
      ++ [networking browser];
    pc' =
      pc
      ++ chat
      ++ [users.req];

    teeniebox = pc' ++ [x11.colemak];
  }