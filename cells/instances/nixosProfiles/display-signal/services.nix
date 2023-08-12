{
  inputs,
  cell,
}: {
  signald = {
    enable = true;
    group = "users";
    socketPath = "/run/signald/signald.sock";
  };
}
