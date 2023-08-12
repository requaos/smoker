{
  inputs,
  cell,
}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      # SDL:
      export SDL_VIDEODRIVER=wayland
      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland
      #export QT_QPA_PLATFORM=wayland-egl
      #export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
      #
      export MOZ_DBUS_REMOTE=1
      #export NIXOS_OZONE_WL=1
    '';
    extraPackages = with inputs.nixpkgs; [
      xwayland
      qt5.qtwayland
      swaylock
      swayidle
    ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   # gtk portal needed to make gtk apps happy
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   gtkUsePortal = true;
  # };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with inputs.nixpkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      # gtkUsePortal = true;
    };
  };
}
