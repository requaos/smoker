{
  config,
  lib,
  pkgs,
  ...
}: {
  services.octoprint = {
    enable = true;
    # port = 5000;
    openFirewall = true;

    plugins = plugins:
      with plugins; [
        # abl-expert
        bedlevelvisualizer
        # costestimation
        # displayprogress
        displaylayerprogress
        # gcodeeditor
        # mqtt
        # octolapse
        octoprint-dashboard
        printtimegenius
        # simpleemergencystop
        stlviewer
        # themeify
        # touchui
      ];
  };
}
