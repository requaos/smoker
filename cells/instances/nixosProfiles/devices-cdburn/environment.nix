{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    cdrkit
    cdrdao
    libsForQt5.k3b
  ];
}
