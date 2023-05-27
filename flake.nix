{
  description = "Required Professionals NixOS Configurations";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";

    extra-substituters = [
      # nix-community
      "https://nix-community.cachix.org"
      # colmena
      "https://colmena.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };

  inputs = {
    blank.url = "github:divnix/blank";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    std = {
      url = "github:divnix/std";
      inputs = {
        blank.follows = "blank";
        nixpkgs.follows = "nixpkgs";
        arion.follows = "arion";
      };
    };

    std-data-collection = {
      url = "github:divnix/std-data-collection";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        std.follows = "std";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        colmena.follows = "colmena";
        nixos-generators.follows = "nixos-generators";
      };
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.flake-compat.follows = "blank";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    hive,
    std,
    ...
  } @ inputs: let
    # I don't need to worry about name collisions.
    # If you think you might, don't do this.
    collect = hive.collect // {renamer = cell: target: "${target}";};
    lib = inputs.nixpkgs.lib // builtins;
  in
    hive.growOn {
      inherit inputs;

      cellsFrom = ./cells;
      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        # library
        (functions "lib")

        # profiles
        (functions "hardwareProfiles")
        (functions "nixosProfiles")
        (functions "homeProfiles")

        # suites
        (functions "nixosSuites")
        (functions "homeSuites")

        # configurations
        nixosConfigurations
        colmenaConfigurations

        # pkgs
        (pkgs "pkgs")

        # devshells
        (devshells "devshells")
      ];

      # To keep proprietary software to a minimum:
      # allowUnfreePredicate
      # Forces us to keep track of proprietary software.
      nixpkgsConfig = {
        allowUnfreePredicate = pkg:
          lib.elem (lib.getName pkg) [
            "discord"
            "clion"
            "vscode"
          ];
        permittedInsecurePackages = [
          "openssl-1.1.1t"
        ];
      };
    } {
      lib = std.pick self ["system" "lib"];
      devShells = std.harvest self ["system" "devshells"];
    } {
      nixosConfigurations = collect self "nixosConfigurations";
      colmenaHive = collect self "colmenaConfigurations";
      # TODO: implement
      # nixosModules = collect self "nixosModules";
      # hmModules = collect self "homeModules";
    };
}
