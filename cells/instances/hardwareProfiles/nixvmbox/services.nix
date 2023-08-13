{
  inputs,
  cell,
}: {
  xserver = {
    dpi = 192;
    displayManager.sessionCommands = ''
      ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 192
      EOF
    '';
  };
}
