{
  inputs,
  cell,
}: {
  xserver = {
    videoDrivers = ["iris"];
    dpi = 192;
    displayManager.sessionCommands = ''
      ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 192
      EOF
    '';
  };
  fwupd = {
    enable = true;
  };
  thermald = {
    enable = true;
  };
  fstrim = {
    enable = true;
  };
  fprintd = {
    tod = {
      enable = true;
      driver = inputs.nixpkgs.libfprint-2-tod1-goodix;
    };
  };
}