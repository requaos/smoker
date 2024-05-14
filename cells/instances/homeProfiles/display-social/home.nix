{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    ## SOCIAL
    zulip
    zulip-term
    element-desktop
    signal-desktop
  ];
}
