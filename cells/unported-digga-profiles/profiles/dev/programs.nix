{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  home-manager.users.${config.vars.username} = {
    # programs.zellij.enable = true;

    home.packages = with pkgs; [
      # tools
      imagemagick
      mitmproxy

      # nix
      std
      nix-diff
      rnix-lsp
      nixpkgs-fmt

      # editors
      # https://helix-editor.com/
      helix
      jetbrains.clion

      # kubernetes
      kubectl
      kubernetes-helm
      cmctl # cert-manager cli
      werf
      argocd

      # aws
      awscli2
      #awslocal
      #aws-mfa
      #terraform
    ];
  };
}
