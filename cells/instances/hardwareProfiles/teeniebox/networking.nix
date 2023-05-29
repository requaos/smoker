{
  inputs,
  cell,
}: {
  useDHCP = cell.lib.mkForce true;
  networkmanager = {
    enable = cell.lib.mkForce true;
  };
}
