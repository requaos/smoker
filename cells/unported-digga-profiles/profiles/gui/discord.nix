{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-21.4.0"
  ];

  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      (
        discord
        # fix to open links correctly
        # .override { nss = pkgs.nss_latest; }
        # .override { withOpenASAR = true; }
        # .overrideAttrs (_: { src = inputs.discord; })
      )
      betterdiscordctl
      #discord-rpc
    ];
  };
}
