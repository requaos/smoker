{
  inputs,
  cell,
}: let
  inherit (cell.configProfiles) fullname email;
in {
  lazygit.enable = true;
  git = {
    enable = true;
    package = inputs.nixpkgs.gitAndTools.gitFull;

    userName = fullname;
    userEmail = email;

    extraConfig = {
      credential = {
        helper = "libsecret";
      };
      core = {
        autocrlf = "false";
      };
      pull = {
        # https://blog.sffc.xyz/post/185195398930/why-you-should-use-git-pull-ff-only-git-is-a
        #rebase = "true";
        ff = "only";
      };
      push = {
        autoSetupRemote = "true";
      };
    };
  };
}
