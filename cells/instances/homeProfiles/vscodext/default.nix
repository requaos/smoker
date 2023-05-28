{
  inputs,
  cell,
}: let
  l = cell.lib // builtins;
  generatedPackages = import ./_sources/generated.nix;
  generatedExtensions = (import ./_code/extensions.nix).extensions;
  excludedExts = [
    "Stylix.stylix"
    "rust-lang.rust-analyzer"
  ];
  extensionFilterFn = ext: (!l.lists.any (pn: pn == "${ext.publisher}.${ext.name}") excludedExts);
in {
  # keep sources this first
  sources = inputs.nixpkgs.callPackage generatedPackages {};

  generatedCodeMarketplaceExtensions = l.filter extensionFilterFn generatedExtensions;

  # then, call packages with `final.callPackage`
  # _ = prev.callPackage (import ./_.nix) { };
}
