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
  }