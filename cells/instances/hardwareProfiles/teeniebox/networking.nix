{
  inputs,
  cell,
}: {
  useDHCP = cell.lib.mkForce true;
  networkmanager = {
    enable = cell.lib.mkForce true;
  };

  # bridge adapter for host-to-vm network visibility in libvirtd
  bridges = {
    "br0" = {
      interfaces = ["wlp0s20f3"];
    };
  };
}
