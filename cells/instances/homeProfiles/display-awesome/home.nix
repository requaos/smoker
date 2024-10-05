{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  packages = with nixpkgs; [
    # neofetch
    #zenith
    htop
    nethogs
    baobab

    betterlockscreen
  ];
}
