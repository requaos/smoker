{
  config,
  inputs,
  cell,
}: {
  services.signald = {
    enable = true;
    group = "users";
    socketPath = "/run/signald/signald.sock";
  };
}
