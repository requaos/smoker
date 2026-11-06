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

    gh
    claude-code
    claude-monitor
    claude-code-router

    # neofetch
    killall
  ];
}
