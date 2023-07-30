{
  inputs,
  cell,
}: {
  hardware = {
    opengl.extraPackages = with inputs.nixpkgs; [
      linuxPackages_testing.nvidiaPackages.vulkan_beta
      linuxPackages_testing.nvidia_x11_vulkan_beta
    ];
    nvidia = {
      nvidiaSettings = true;

      # only needed for optimus-enabled configurations, conflicts with modesetting driver for displaylink
      #modesetting.enable = true;
    };
  };

  boot = {
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  environment.systemPackages = with inputs.nixpkgs; [
    linuxPackages_testing.nvidiaPackages.vulkan_beta
    linuxPackages_testing.nvidia_x11_vulkan_beta
    #linuxPackages_testing.nvidiabl # laptop screen brightness utility (find another way)
    vulkan-tools
    pciutils
    cudatoolkit
    zenith-nvidia
  ];

  systemd.services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${inputs.nixpkgs.linuxPackages_testing.nvidiaPackages.vulkan_beta.bin}/bin/nvidia-smi";
  };

  programs.gamescope = {
    env = {
      # unsure if these are really needed when nvidia gpu is set
      # to always-on, rather than optimus/prime dual-gpu mode.
      #__NV_PRIME_RENDER_OFFLOAD = "1";
      #__VK_LAYER_NV_optimus = "NVIDIA_only";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
