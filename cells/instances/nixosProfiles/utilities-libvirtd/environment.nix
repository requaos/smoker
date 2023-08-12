{
  inputs,
  cell,
}:
with cell.lib; let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    virt-manager
  ];
}
