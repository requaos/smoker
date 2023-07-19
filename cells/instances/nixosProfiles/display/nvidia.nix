{
  inputs,
  cell,
}: {
  services.xserver = {
    videoDrivers = cell.lib.mkForce ["nvidia"];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    prime = {
      reverseSync.enable = true;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0"; # dedicated gpu
      intelBusId = "PCI:0:2:0";
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
