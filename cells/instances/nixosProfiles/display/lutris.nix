{
  inputs,
  cell,
}: {
  environment.systemPackages = with inputs.nixpkgs; [
    lutris
    protonup-qt
    protontricks
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

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';
}
