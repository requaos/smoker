{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    gimp-with-plugins
    inkscape-with-extensions
    flowblade
  ];
}
