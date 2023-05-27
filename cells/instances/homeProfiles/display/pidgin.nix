{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    (pidgin.override {
      plugins = with nixpkgs; [
        pidgin-opensteamworks
        pidgin-window-merge
        purple-discord
        purple-matrix
        purple-signald
        # pidgin-indicator
        # pidgin-latex
        # pidgin-xmpp-receipts
        # purple-slack
      ];
    })
  ];
}
