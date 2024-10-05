{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in {
  larva = {
    imports = [
      nixosProfiles.bootstrap
    ];
  };
  # overrides = {
  #   disabledModules = ["services/networking/hickory-dns.nix"];
  #   imports = [./nixosOverrides/trust-dns.nix];
  # };
}
