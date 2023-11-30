{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    pipewire
    easyeffects

    # pw-viz <-- was cool eGui native rust graph vizualizer, but it broke and isn't
    # maintained, so we should just write lua scripts to auto-set our graphs without
    # needing a visual interface.
    # see buukubox environment.nix for lua script example for setting graph rules on boot:
    # use `pw-cli ls` to list the current graph for references in your lua scripts.
    wireplumber

    # utilities to support pulseaudio stuff under pipewire
    pulseaudio
    pamixer

    # alsa stuff
    alsa-utils
  ];
}
