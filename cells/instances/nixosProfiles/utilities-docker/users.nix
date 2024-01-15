{...}: let
  inherit (cell.configProfiles) username fullname;
in {
  users.${username}.extraGroups = ["docker"];
}
