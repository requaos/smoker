{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with config.lib.stylix.colors.withHashtag; {
  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  environment.systemPackages = with pkgs; [
    pciutils
    cudatoolkit
  ];

  systemd.services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${config.boot.kernelPackages.nvidiaPackages.beta.bin}/bin/nvidia-smi";
  };
}
