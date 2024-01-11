{
  inputs,
  cell,
}: {
  services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${inputs.nixpkgs.linuxPackages_latest.nvidiaPackages.vulkan_beta.bin}/bin/nvidia-smi";
  };
}
