{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable sound with PipeWire
  # https://github.com/NixOS/nixpkgs/issues/102547
  # sound.enable = true;
  # sound.mediaKeys.enable = true;
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # required for easyeffects settings to save correctly.
  programs.dconf.enable = true;

  home-manager.users.${config.vars.username} = {
    # home.packages = with pkgs; [
    #   helvum
    # ];

    # services.easyeffects = {
    #   enable = true;
    #   # preset = "";
    # };
  };
}
