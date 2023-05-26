{
  inputs,
  cell,
}: {
    systemPackages = with inputs.nixpkgs; [
        # CORE UTILS
        vim
        gnused # sed
        tree

        # MODERN CORE UTILS
        topgrade
        tealdeer # tldr
        # starship
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
    ];
}