{
  inputs,
  cell,
}: {
  opengl.extraPackages = with inputs.nixpkgs; [
    linuxPackages_6_5.nvidiaPackages.vulkan_beta
    linuxPackages_6_5.nvidia_x11_vulkan_beta
  ];
  nvidia = {
    nvidiaSettings = true;

    # only needed for optimus-enabled configurations, conflicts with modesetting driver for displaylink
    #modesetting.enable = true;
  };
}
