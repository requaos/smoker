{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  packages = with nixpkgs; [
    # swaylock # lockscreen
    # swayidle # idle screen locker
    wl-clipboard # clipboard stdout/stdin integration
    mako
    # wofi
    # waybar
    grim # screenshots
    slurp # region selection
  ];
}
