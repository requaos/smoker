{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
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

    # fonts
    powerline-fonts

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
    aws-rotate-key
  ];
}
