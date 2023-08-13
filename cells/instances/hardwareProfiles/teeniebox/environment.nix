{
  inputs,
  cell,
}: {
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  systemPackages = with inputs.nixpkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good

    # broken until https://github.com/NixOS/nixpkgs/pull/244378 is merged in.
    #gst_all_1.icamerasrc-ipu6ep

    mesa
    vulkan-tools # use vkcube to test if vulkan is working properly
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    virglrenderer
    xdg-desktop-portal-wlr

    # fprintd-tod == fprintd /w (T)ouch (O)EM (D)rivers
    fprintd-tod
    libfprint-tod
  ];
}