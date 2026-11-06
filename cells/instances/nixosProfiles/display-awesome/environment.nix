{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    xarchiver
    vscode

    # brave was removed from nixpkgs (2026-11); users get google-chrome via
    # the display-common home profile instead
  ];
}
