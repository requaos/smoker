{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #inputs.umberwm.defaultPackage.x86_64-linux
  ];

  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      inputs.umberwm.defaultPackage.x86_64-linux
    ];
  };
}
