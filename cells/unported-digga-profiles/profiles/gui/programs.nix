{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  base16-schemes = inputs.base16-schemes;
in {
  home-manager.users.${config.vars.username} = {
    home.pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
      # size = if meta.scalingFactor <= 1.25 then 16 else 32;
      # x11.enable = true; # moved to xserver.nix
    };
    #home.pointerCursor.x11.enable = true;

    gtk.enable = true;
    # qt.enable = true;

    # services.redshift = {};
    # services.rsibreak.enable = true;

    programs.alacritty.enable = true;

    #programs.chromium = {
    #  enable = true;
    #};

    #programs.firefox = {
    #  enable = true;
    #  profiles.req = {
    #    settings = {
    #      "browser.startup.homepage" = "https://nixos.org";
    #    };
    #  };
    #  extensions = with nur.repos.rycee.firefox-addons; [
    #    https-everywhere
    #    privacy-badger
    #  ];
    #};

    home.packages = with pkgs; [
      # fix links
      xdg-utils

      nnn
      xfce.thunar

      brave
      chromium
      firefox
      google-chrome

      # thunderbird
      # thunderbird-wayland
      # thunderbird-bin

      bitwarden
      bitwarden-cli
      #rbw

      ## SOCIAL
      # see discord.nix
      zulip
      zulip-term
      element-desktop
      signal-desktop
      # zoom-usawds
      # teams
      # jami-client-qt
      # jami-daemon
      # jitsi

      # NOTES AND PRODUCTIVITY
      super-productivity
      obsidian
      notion-app-enhanced
      # logseq
      # appflowy
      # anytype
      # standardnotes

      # gimp
      # vlc

      baobab
    ];

    # make xdg links work correctly.
    xdg = {
      # enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "scheme-handler/http" = "google-chrome.desktop";
          "scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
          "x-scheme-handler/unknown" = "google-chrome.desktop";
          "x-scheme-handler/notion" = "notion-app-enhanced.desktop";
          "text/html" = "google-chrome.desktop";
          "application/pdf" = "google-chrome.desktop";
        };
      };
    };

    # make links work in electron correctly.
    home.sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.google-chrome}/bin/google-chrome";
    };
  };
}
