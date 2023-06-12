{
  inputs,
  cell,
}: {
  services.xserver = {
    videoDrivers = inputs.lib.mkForce ["nvidia"];
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
