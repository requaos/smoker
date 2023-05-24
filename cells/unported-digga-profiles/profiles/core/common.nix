{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  # Sets nrdxp.cachix.org binary cache which just speeds up some builds
  imports = [../cachix];

  environment = {
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
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
    ];

    # Starship is a fast and featureful shell prompt
    # starship.toml has sane defaults that can be changed there
    # shellInit = ''
    #   export STARSHIP_CONFIG=${
    #     pkgs.writeText "starship.toml"
    #     (fileContents ./starship.toml)
    #   }
    # '';
  };

  fonts.fonts = with pkgs; [
    # (nerdfonts.override { fonts = [
    #   "Hack"
    # ]; })
    nerdfonts
    hack-font
    dejavu_fonts
    roboto
    # roboto-mono
  ];

  nix = {
    settings = {
      # enable flakes
      # experimental-features = [ "nix-command" "flakes" ];

      # Improve nix store disk usage
      # gc.automatic = true;

      # Prevents impurities in builds
      sandbox = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
    };

    # Generally useful nix option defaults
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
}
