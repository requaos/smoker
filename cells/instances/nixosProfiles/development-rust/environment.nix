{ inputs, cell, }: {
  systemPackages = with builtins.removeAttrs
    (
      inputs.fenix.packages.latest //
      { inherit (inputs.fenix.packages) rust-analyzer; }
    )
    [ "withComponents" ]; [
      cargo
      clippy
      rust-src
      rustc
      rustfmt
      rust-analyzer
    ];
}
