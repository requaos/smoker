{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  dbus.enable = true;

  gnome.gnome-keyring.enable = true;

  # Printers
  avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # Service that makes Out of Memory Killer more effective
  earlyoom.enable = true;
}
