{ ... }:
let
  username = "req";
in
{
  signald = {
    user = username;
  };
}
