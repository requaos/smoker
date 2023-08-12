{
  inputs,
  cell,
}: {
  gamescope = {
    env = {
      # unsure if these are really needed when nvidia gpu is set
      # to always-on, rather than optimus/prime dual-gpu mode.
      #__NV_PRIME_RENDER_OFFLOAD = "1";
      #__VK_LAYER_NV_optimus = "NVIDIA_only";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
