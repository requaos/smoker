{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
  };

  environment.systemPackages = with pkgs; [
    # provides: bluetoothctl
    bluez
  ];

  services.blueman = {
    enable = true;
  };
}
