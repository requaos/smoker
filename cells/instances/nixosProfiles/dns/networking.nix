{
  nameservers = ["127.0.0.1"];
  firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
}
