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
    inputs.maimpkgs.legacyPackages.x86_64-linux.maim
    pciutils
    file

    gnumake
    gcc
  ];
}
