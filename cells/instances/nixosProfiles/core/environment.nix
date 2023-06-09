{
  inputs,
  cell,
}: {
  # Selection of sysadmin tools that can come in handy
  systemPackages = with inputs.nixpkgs; [
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

    # maybe linux/bash specific. YOLO
    mcfly

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
    zenith
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
}
