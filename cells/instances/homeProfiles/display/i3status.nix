{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    neofetch
    #zenith
    htop
    nethogs
    baobab
  ];

  programs.i3status-rust = {
    enable = true;
  };
}
