{
  inputs,
  cell,
}: {
  dconf.enable = true;
  i3lock = {
    package = inputs.nixpkgs.i3lock-color;
  };
}
