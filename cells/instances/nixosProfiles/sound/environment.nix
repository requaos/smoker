{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    pipewire
    helvum
    easyeffects

    # utilities to support pulseaudio stuff under pipewire
    pulseaudio
    pamixer

    # alsa stuff
    alsa-utils
  ];
}
