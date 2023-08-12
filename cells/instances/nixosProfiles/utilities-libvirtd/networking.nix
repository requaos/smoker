{
  inputs,
  cell,
}:
with cell.lib; let
  bridgeName = "br0";
  hostInterface = "wlp0s20f3";
  infiniteLeaseTime = true;
in {
  # libvirt uses 192.168.122.0
  bridges."${bridgeName}".interfaces = [];
  interfaces."${bridgeName}" = {
    ipv4.addresses = [
      {
        address = "192.168.122.1";
        prefixLength = 24;
      }
    ];
  };
  nat = {
    enable = true;
    internalInterfaces = [bridgeName];
    externalInterface = hostInterface;
    extraCommands = "iptables -t nat -A POSTROUTING -o ${hostInterface} -j MASQUERADE";
  };
  dhcpcd = {
    enable = true;
    allowInterfaces = [bridgeName hostInterface];
    extraConfig = ''
      interface ${bridgeName}
      noipv6rs
      static routers=192.168.122.1
      static broadcast_address=192.168.122.255
      static subnet_mask=255.255.255.0
      static domain_name_servers=1.1.1.1, 8.8.8.8, 208.67.222.222, 1.0.0.1, 8.8.4.4, 208.67.220.220
      static leasetime=-1
      static ip_address=192.168.122.100/24
    '';
  };
}
