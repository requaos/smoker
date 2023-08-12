{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    nethogs
  ];
}
