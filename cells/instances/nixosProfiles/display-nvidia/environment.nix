{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    linuxPackages_6_5.nvidiaPackages.vulkan_beta
    linuxPackages_6_5.nvidia_x11_vulkan_beta
    # linuxPackages_testing.nvidiabl # laptop screen brightness utility (find another way)
    vulkan-tools
    pciutils
    cudatoolkit
    #zenith-nvidia #not as useful as it seemed
  ];
}
