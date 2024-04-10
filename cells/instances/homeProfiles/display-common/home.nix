{
  inputs,
  cell,
}: {
  pointerCursor = {
    package = inputs.nixpkgs.gnome.adwaita-icon-theme;
    name = "Adwaita-Dark";
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
    # bitwarden
    # bitwarden-cli
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
    # super-productivity
    # obsidian
    # notion-app-enhanced
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
}
