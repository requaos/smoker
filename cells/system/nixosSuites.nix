{ inputs
, cell
,
}:
let
  inherit (cell) nixosProfiles;
in
{
  larva = {
    imports = [
      nixosProfiles.bootstrap
    ];
  };
  overrides = {
    disabledModules = [ "services/networking/trust-dns.nix" ];
    imports = [ ./nixosOverrides/trust-dns.nix ];
  };
}
