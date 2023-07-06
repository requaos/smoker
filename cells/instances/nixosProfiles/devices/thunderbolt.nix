{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  services = {
    hardware.bolt.enable = true;
    udev.extraRules = ''
      # Always authorize thunderbolt connections when they are plugged in.
      # This is to make sure the USB hub of Thunderbolt is working.
      ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
    '';
  };
  environment.systemPackages = with nixpkgs; [
    thunderbolt
  ];
}
