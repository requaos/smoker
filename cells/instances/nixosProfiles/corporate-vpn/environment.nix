{
  inputs,
  cell,
}: {
  systemPackages = with inputs.awsvpnclient; [
    # Usage: awsvpnclient start --config ~/path/to/config.ovpn
    packages.awsvpnclient
  ];
}
