{
  inputs,
  cell,
}: {
  loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 25;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
