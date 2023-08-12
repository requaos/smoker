{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    xorg.xdpyinfo
    autorandr
    libnotify
    xterm
    xclip
    maim
    pciutils
    file

    gnumake
    gcc
  ];
}
