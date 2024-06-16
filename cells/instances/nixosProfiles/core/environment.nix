{
  inputs,
  cell,
}: {
  # Selection of sysadmin tools that can come in handy
  systemPackages = with inputs.nixpkgs; [
    # niff tool, rust port of nvd should be used instead, but...
    nvd

    # TODO: must come from unstable channel
    # alejandra
    binutils
    coreutils
    curl
    dnsutils
    fd
    git
    bottom
    jq
    manix
    moreutils
    nix-index
    nmap
    pciutils
    ripgrep
    skim
    whois
    graphviz
    unzip
    p7zip

    # magic shell history
    # atuin
    blesh

    # debug info
    dmidecode

    # maybe linux/bash specific. YOLO
    mcfly
    brightnessctl

    # CORE UTILS
    vim
    gnused # sed
    tree

    # MODERN CORE UTILS
    topgrade
    tealdeer # tldr

    ripgrep
    fd

    # NETWORK TOOLS
    drill
    curl
    wget
    # maybe this doesn't go here, or we flag as optional against `home-manager.users.{userName}.programs.networkmanager.enable = true'
    networkmanager

    # PERF TOOLS
    htop
    nethogs
    # radeontop
    # nvtop
  ];

  shellAliases = {
    # fix nixos-option for flake compat
    #nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
    userctl = "systemctl --user";
  };
  variables = {
    EDITOR = "${inputs.nixpkgs.vim}/bin/vim";
    VISUAL = "${inputs.nixpkgs.vim}/bin/vim";
  };
}
