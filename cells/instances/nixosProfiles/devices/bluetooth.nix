{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  hardware.bluetooth = {
    enable = true;
    package = nixpkgs.bluez;
  };

  environment.systemPackages = with nixpkgs; [
    # provides: bluetoothctl
    bluez
  ];

  services.blueman = {
    enable = true;
  };
}
