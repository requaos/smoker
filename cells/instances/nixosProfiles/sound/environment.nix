{ inputs
, cell
,
}: {
  systemPackages = with inputs.nixpkgs; [
    pipewire
    pw-viz
    easyeffects
    wireplumber

    # utilities to support pulseaudio stuff under pipewire
    pulseaudio
    pamixer

    # alsa stuff
    alsa-utils
  ];
}
