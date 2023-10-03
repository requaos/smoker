{ ... }:
let
  inherit (cell.configProfiles) username fullname email;
in
{
  users.${username} = {
    programs = {
      git = {
        userName = fullname;
        userEmail = email;
      };
    };
  };
}
