{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    # tools
    imagemagick
    pango
    zenity
    # surrealist
    # TODO: Runtime dependencies for mitmproxy-10.2.1-py3-none-any.whl:
    #       - aioquic not installed
    #mitmproxy

    # editors
    # https://helix-editor.com/
    helix
    # jetbrains.clion

    # .Net
    jetbrains.rider
    (with dotnetCorePackages;
      combinePackages [
        sdk_7_0
        sdk_8_0
        sdk_9_0
      ])
    protobuf

    # java
    #jetbrains.jdk

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
