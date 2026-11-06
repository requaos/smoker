{
  inputs,
  cell,
}: {
  packages = with inputs.nixpkgs; [
    ## SOCIAL
    zulip
    # upstream test suite currently fails in the sandbox; the client itself
    # is unaffected, so disable pytestCheckHook rather than pinning nixpkgs
    (zulip-term.overrideAttrs (old: {dontUsePytestCheck = true;}))
    element-desktop
    signal-desktop
  ];
}
