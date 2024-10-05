{
  config,
  inputs,
  cell,
}: {
  graphics.extraPackages = with inputs.nixpkgs; [
    config.boot.kernelPackages.nvidiaPackages.vulkan_beta
    config.boot.kernelPackages.nvidia_x11_vulkan_beta
  ];
  nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

    # only needed for optimus-enabled configurations, conflicts with modesetting driver for displaylink
    modesetting.enable = true;
  };
}
