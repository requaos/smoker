{
  inputs,
  cell,
}: {
  dconf.enable = true;
  i3lock = {
    package = inputs.nixpkgs.i3lock-color;
  };
  thunar.plugins = with inputs.nixpkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
}
