{...}: let
  username = "req";
  emailuser = "reqpro";
  domain = "requaos.com";
  fullname = "Neil Skinner";
in {
  users.${username} = {
    programs = {
      git = {
        userName = fullname;
        userEmail = "${emailuser}@${domain}";
      };
    };
  };
}
