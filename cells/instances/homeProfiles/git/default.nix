{
  programs = {
    lazygit.enable = true;
    git = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}