{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    cdrkit
    cdrdao
    (kdePackages.k3b.override {transcode = null;})
  ];
}
