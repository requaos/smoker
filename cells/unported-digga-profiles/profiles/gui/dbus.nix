{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.dbus.enable = true;
}
