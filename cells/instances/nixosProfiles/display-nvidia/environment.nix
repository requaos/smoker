{
  config,
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    config.boot.kernelPackages.nvidiaPackages.vulkan_beta
    config.boot.kernelPackages.nvidia_x11_vulkan_beta
    # Abandonded
    # config.boot.kernelPackages.nvidiabl
    vulkan-tools
    pciutils
    cudatoolkit
    #zenith-nvidia #not as useful as it seemed
  ];
  variables = {
    # Necessary to correctly enable va-api (video codec hardware
    # acceleration). If this isn't set, the libvdpau backend will be
    # picked, and that one doesn't work with most things, including
    # Firefox.
    LIBVA_DRIVER_NAME = "nvidia";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on nvidia
    WLR_NO_HARDWARE_CURSORS = "1";

    # Required to use va-api it in Firefox. See
    # https://github.com/elFarto/nvidia-vaapi-driver/issues/96
    MOZ_DISABLE_RDD_SANDBOX = "1";
    # It appears that the normal rendering mode is broken on recent
    # nvidia drivers:
    # https://github.com/elFarto/nvidia-vaapi-driver/issues/213#issuecomment-1585584038
    NVD_BACKEND = "direct";

    # Wayland Compat stuff not currently needed while still on X:
    # # Required for firefox 98+, see:
    # # https://github.com/elFarto/nvidia-vaapi-driver#firefox
    # EGL_PLATFORM = "wayland";
    # # Required to run the correct GBM backend for nvidia GPUs on wayland
    # GBM_BACKEND = "nvidia-drm";
  };
}
