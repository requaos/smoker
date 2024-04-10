{
  inputs,
  cell,
}:
with cell.lib; let
  inherit (inputs) nixpkgs;

  hostInterface = "wlp0s20f3";
  hostMacAddress = "de:ad:be:ef:de:ad";
in {
  useDHCP = cell.lib.mkForce true;
  networkmanager = {
    enable = cell.lib.mkForce true;

    # For teh random wierdos that constrain network accress by mac-address (like I couldn't sniff a connected users mac address and spoof it, wtf)
    wifi.scanRandMacAddress = cell.lib.mkForce false;
  };
  firewall = {
    enable = cell.lib.mkForce true;
  };

  #useNetworkd = true;
  # interfaces."${hostInterface}".macAddress = hostMacAddress;
  # localCommands = ''
  #   link set dev "${hostInterface}" down
  #   link set "${hostInterface}" address "${hostMacAddress}"
  #   link set dev "${hostInterface}" up
  # '';
}
