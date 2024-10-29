{
  inputs,
  cell,
  config,
}: let
  inherit (inputs) nixpkgs;
in {
  openvpn3 = {
    enable = true;
    package = nixpkgs.openvpn3.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          ./fix-tests.patch # point to wherever you have this file, or use something like `fetchpatch`
        ];
      enableSystemdResolved = config.services.resolved.enable;
    });
  };
}
