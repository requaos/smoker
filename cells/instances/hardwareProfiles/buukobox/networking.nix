{
  inputs,
  cell,
}: {
  useDHCP = cell.lib.mkForce true;
  networkmanager = {
    enable = cell.lib.mkForce true;

    # For teh random wierdos that constrain network accress by mac-address (like I couldn't sniff a connected users mac address and spoof it, wtf)
    wifi.scanRandMacAddress = cell.lib.mkForce false;
  };
  firewall = {
    enable = cell.lib.mkForce true;
  };
}
