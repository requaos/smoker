{
  inputs,
  cell,
}: let
  inherit (cell.configProfiles) username;
in {
  users.${username} = {
    extraGroups = [
      "dialout"
    ];
  };
}
