{
  inputs,
  cell,
}: {
  portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with inputs.nixpkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    # gtkUsePortal = true;
  };
}
