{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./common.nix
  ];

  nix = {
    settings = {
      # This is just a representation of the nix default
      # system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

      auto-optimise-store = true;
      # TODO: fix this...
      # error: A definition for option `nix.settings.optimise' is not of type `Nix config atom (null, bool, int, float, str, path or package) or list of (Nix config atom (null, bool, int, float, str, path or package))'.
      # optimise.automatic = true;

      allowed-users = ["@wheel"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  environment = {
    systemPackages = with pkgs; [
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
  };

  fonts.fontconfig.defaultFonts = {
    monospace = ["DejaVu Sans Mono for Powerline"];
    sansSerif = ["DejaVu Sans"];
  };

  # programs.bash = {
  #   # Enable starship
  #   promptInit = ''
  #     eval "$(${pkgs.starship}/bin/starship init bash)"
  #   '';
  #   # Enable direnv, a tool for managing shell environments
  #   interactiveShellInit = ''
  #     eval "$(${pkgs.direnv}/bin/direnv hook bash)"
  #   '';
  # };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  # Service that makes Out of Memory Killer more effective
  # services.earlyoom.enable = true;
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
