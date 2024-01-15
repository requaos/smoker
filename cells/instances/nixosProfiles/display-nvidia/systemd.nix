{
  config,
  inputs,
  cell,
}: {
  services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${config.boot.kernelPackages.nvidiaPackages.vulkan_beta.bin}/bin/nvidia-smi";
  };
}
