{
  inputs,
  cell,
}: {
  settings.Manager = {
    DefaultLimitNOFILE = "1048576";
  };

  #user.extraConfig = ''
  #  DefaultLimitNOFILE=1048576
  #'';
}
