{
  inputs,
  cell,
}: {
  systemPackages = with builtins.removeAttrs
  (
    inputs.fenix.packages.latest
    // {inherit (inputs.fenix.packages) rust-analyzer targets;}
  )
  ["withComponents"]; [
    cargo
    clippy
    rust-src
    rustc
    rustfmt
    rust-analyzer
    targets.wasm32-unknown-unknown.latest.rust-std

    # Necessary for the openssl-sys crate:
    inputs.nixpkgs.openssl_1_1
    inputs.nixpkgs.pkg-config

    inputs.nixpkgs.jetbrains.rust-rover
  ];
  sessionVariables = {
    RUST_SRC_PATH = "${inputs.fenix.packages.latest.rust-src}";
    PKG_CONFIG_PATH = "${inputs.nixpkgs.openssl_1_1.dev}/lib/pkgconfig";
    OPENSSL_DIR = "${inputs.nixpkgs.openssl_1_1}";
    LD_LIBRARY_PATH = cell.lib.makeLibraryPath [inputs.nixpkgs.openssl_1_1];
  };
}
