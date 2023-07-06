{
  inputs,
  cell,
}: {
  # Selection of sysadmin tools that can come in handy
  environment.systemPackages = with inputs.nixpkgs; [
    slack
  ];
}
