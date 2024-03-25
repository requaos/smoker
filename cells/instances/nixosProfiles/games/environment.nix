{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    lutris
    protonup-qt
    protontricks
    winetricks
    xivlauncher
    gamescope
    scanmem
    libselinux

    proton-caller
    # jdk
    wine64
    # jdk8
    # retroarchFull
    # libretro.parallel-n64
    vulkan-tools
    #(lutris.override {
    # extraPkgs = pkgs: [
    #   innoextract
    #   p7zip
    #   SDL2
    #   SDL2_ttf
    #   SDL2_gfx
    #   SDL2_image
    #   SDL2_mixer
    #   SDL2_net
    #   winetricks
    #   lib32-vulkan-intel
    # ];
    #})
  ];
}
