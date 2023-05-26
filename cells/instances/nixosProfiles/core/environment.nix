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
    tealdeer
    whois

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

    # PERF TOOLS
    zenith
    htop
    nethogs
    # radeontop
    # nvtop

    # non-darwin, figure that stuff out later
    dosfstools
    gptfdisk
    iputils
    usbutils
    utillinux

    neofetch
    killall
  ];

  shellAliases = {
    # fix nixos-option for flake compat
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
    userctl = "systemctl --user";
  };

  etc."coredns/requaos.com.db" = {
    text = ''
      $ORIGIN requaos.com.
      @	3600 IN	SOA sns.dns.icann.org. noc.dns.icann.org. (
              2017042745 ; serial
              7200       ; refresh (2 hours)
              3600       ; retry (1 hour)
              1209600    ; expire (2 weeks)
              3600       ; minimum (1 hour)
              )

        3600 IN NS a.iana-servers.net.
        3600 IN NS b.iana-servers.net.
      @       IN A     192.168.1.2
      www     IN A     192.168.1.2
      *       IN A     192.168.1.2
      teleport IN A 65.32.55.119
      *.teleport IN A 65.32.55.119
    '';
  };
}
