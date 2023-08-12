{
  inputs,
  cell,
}: {
  # Selection of sysadmin tools that can come in handy
  systemPackages = with inputs.nixpkgs; [
    slack
  ];
}
