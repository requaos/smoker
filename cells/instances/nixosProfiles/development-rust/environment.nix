{ inputs, cell, }: {
  systemPackages = with builtins.removeAttrs
    (
      inputs.fenix.packages.latest //
      { inherit (inputs.fenix.packages) rust-analyzer targets; }
    )
    [ "withComponents" ]; [
      cargo
      clippy
      rust-src
      rustc
      rustfmt
      rust-analyzer
      targets.wasm32-unknown-unknown.latest.rust-std
    ];
}
