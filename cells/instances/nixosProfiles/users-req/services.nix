{ ... }:
let
  inherit (cell.configProfiles) username;
in
{
  signald = {
    user = username;
  };
}
