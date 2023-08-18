{
  inputs,
  cell,
}: {
  pam.services = {
    sudo.fprintAuth = true;
    i3lock.fprintAuth = true;
    lightdm.fprintAuth = true;
    login.fprintAuth = true;
    xscreensaver.fprintAuth = true;
    swaylock.fprintAuth = true;
  };
}
