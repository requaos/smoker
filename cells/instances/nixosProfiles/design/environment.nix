{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    # gimp-with-plugins
    inkscape-with-extensions
    flowblade

    # coms
    mumble
    # mumble_overlay

    # oversight
    lens
  ];
}
