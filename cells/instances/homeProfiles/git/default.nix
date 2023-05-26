{
  programs = {
    lazygit.enable = true;
    git = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      extraConfig = {
        core = {
          autocrlf = "input";
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
  };
}