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
    dotnet-sdk_8
    protobuf

    # java
    #jetbrains.jdk

    # fonts
    powerline-fonts

    # kubernetes
    kubectl
    kubernetes-helm
    cmctl # cert-manager cli
    werf
    argocd

    # iac
    terraform

    # aws
    awscli
    # awscli2 seems to be having some python/font problems, let's check back later since awscli v1 works fine
    #awscli2
    #awslocal
    #aws-mfa
    #terraform
    aws-rotate-key
    _1password-gui
  ];
}
