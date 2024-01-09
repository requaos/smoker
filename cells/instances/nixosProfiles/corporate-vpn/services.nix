{
  inputs,
  cell,
}: {
  openvpn.servers = {
    officeVPN = {
      config = ''config /home/req/CalamuVPN/calamu-vpn.ovpn '';
      updateResolvConf = true;
    };
  };
}
