{
  # Setting nrdxp.cachix.org binary cache which just speeds up some builds
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nrdxp.cachix.org"
        "https://nix-community.cachix.org"
        "https://colmena.cachix.org"
        "https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
  };
}
