{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    # Linux, non-darwin, packages
    dosfstools
    gptfdisk
    iputils
    usbutils
    utillinux

    # neofetch
    killall
  ];
}
