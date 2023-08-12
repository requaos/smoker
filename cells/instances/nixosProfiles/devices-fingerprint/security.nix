{
  inputs,
  cell,
}: {
  pam.services = {
    login.fprintAuth = true;
    xscreensaver.fprintAuth = true;
    swaylock.fprintAuth = true;
  };
}
