{
  inputs,
  cell,
}:
with inputs.nixos-hardware.nixosModules; [
  common-pc-ssd
  common-pc-laptop
  common-cpu-intel
]
