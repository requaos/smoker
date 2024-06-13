{
  inputs,
  cell,
}: {
  configFile = {
    "nushell/config.nu" = {
      source = ./config.nu;
      force = true;
    };
  };
}
