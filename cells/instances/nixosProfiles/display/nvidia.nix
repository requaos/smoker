{
  inputs,
  cell,
}: {
  services.xserver = {
    videoDrivers = ["nvidia"];
  };
  hardware = {
    opengl.extraPackages = with inputs.nixpkgs; [
      linuxPackages_testing.nvidiaPackages.vulkan_beta
      linuxPackages_testing.nvidia_x11_vulkan_beta
    ];
    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
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
}
