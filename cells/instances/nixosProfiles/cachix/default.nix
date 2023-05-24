{
  nix.settings = {
    substituters = ["https://cache.nixos.org/"];

    trusted-substituters = [
      # nix-community
      "https://nix-community.cachix.org"
      # colmena
      "https://colmena.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };
}