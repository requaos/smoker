{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    pipewire
    qpwgraph
    pamixer
  ];
}
