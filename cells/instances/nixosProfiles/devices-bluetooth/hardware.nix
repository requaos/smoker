{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  bluetooth = {
    enable = true;
    package = nixpkgs.bluez;
  };
}
