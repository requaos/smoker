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
    # awscli v1 is broken in nixpkgs-unstable (runtime-deps check fails against
    # the newer botocore/s3transfer); awscli2 works fine now
    awscli2
    #awslocal
    #aws-mfa
    #terraform
    aws-rotate-key
    _1password-gui
  ];
}
