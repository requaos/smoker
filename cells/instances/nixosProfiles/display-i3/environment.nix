{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    xarchiver
  ];
}
