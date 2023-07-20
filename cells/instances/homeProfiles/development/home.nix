{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    # tools
    imagemagick
    mitmproxy
    pango
    gnome.zenity

    # nix
    #std
    nix-diff
    rnix-lsp
    nixpkgs-fmt
    alejandra
    treefmt

    # editors
    # https://helix-editor.com/
    helix
    jetbrains.clion

    # .Net
    jetbrains.rider
    dotnet-sdk

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
    _1password-gui
  ];
}
