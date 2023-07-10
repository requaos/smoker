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

  environment.systemPackages = with inputs.nixpkgs; [
    pciutils
    cudatoolkit
  ];

  systemd.services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${inputs.nixpkgs.linuxPackages_testing.nvidiaPackages.beta.bin}/bin/nvidia-smi";
  };
}
