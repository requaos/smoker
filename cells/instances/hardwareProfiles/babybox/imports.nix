{
  inputs,
  cell,
}:
with inputs.nixos-hardware.nixosModules; [
  common-cpu-intel
  # common-gpu-intel
]
