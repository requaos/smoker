{
  programs.git = {
    userName = "requaos";
    userEmail = "reqpro@requaos.com";

    extraConfig = {
      github.user = "requaos";
    };

    signing = {
      key = null;
      signByDefault = true;
    };
  };
}