{
  config,
  inputs,
  cell,
}: {
  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  environment.systemPackages = with inputs.nixpkgs; [
    pciutils
    cudatoolkit
  ];

  systemd.services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${config.boot.kernelPackages.nvidiaPackages.beta.bin}/bin/nvidia-smi";
  };
}
