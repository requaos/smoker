{
  inputs,
  cell,
}: {
  environment.systemPackages = with inputs.nixpkgs; [
    lutris
    protonup-qt
    protontricks
    winetricks
    xivlauncher
    gamescope
    scanmem
    #(lutris.override {
    #  extraPkgs = pkgs: [
    #    innoextract
    #    p7zip
    #    SDL2
    #    SDL2_ttf
    #    SDL2_gfx
    #    SDL2_image
    #    SDL2_mixer
    #    SDL2_net
    #    winetricks
    #    lib32-vulkan-intel
    #  ];
    #})
  ];

  programs.gamescope = {
    enable = true;
  };

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';
}
