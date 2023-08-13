{
  inputs,
  cell,
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
  ];
}
