{
  inputs,
  cell,
}: {
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2 -Dawt.useSystemAAFontSettings=lcd";
  };
  systemPackages = with inputs.nixpkgs; [
    mesa
    vulkan-tools # use vkcube to test if vulkan is working properly
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    virglrenderer
    xdg-desktop-portal-wlr
    v4l2-relayd
  ];
}
