{
  inputs,
  cell,
}: {
  gtk.enable = true;

  programs.alacritty.enable = true;

  home = {
    pointerCursor = {
      package = inputs.nixpkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
      # size = if meta.scalingFactor <= 1.25 then 16 else 32;
    };

    packages = with inputs.nixpkgs; [
      # fix links
      xdg-utils
      nnn
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      archiver
      # brave
      # chromium
      # firefox
      google-chrome
      # thunderbird
      # thunderbird-wayland
      # thunderbird-bin
      bitwarden
      bitwarden-cli
      betterlockscreen
      maim
      #rbw

      # icons for lutris
      dracula-icon-theme

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

    # make links work in electron correctly.
    sessionVariables = {
      DEFAULT_BROWSER = "${inputs.nixpkgs.google-chrome}/bin/google-chrome";
    };
  };

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
}
