{
  inputs,
  cell,
}: {
  programs = {
    lazygit.enable = true;
    git = {
      enable = true;
      package = inputs.nixpkgs.gitAndTools.gitFull;

      extraConfig = {
        credential = {
          helper = "libsecret";
        };
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
