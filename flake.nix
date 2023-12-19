{
  description = "Required Professionals NixOS Configurations";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    blank.url = "github:divnix/blank";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    devshell.url = "github:numtide/devshell";

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        colmena.follows = "colmena";
      };
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.flake-compat.follows = "blank";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
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

    aagl-gtk-on-nix = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    from-yaml = {
      url = "github:pegasust/fromYaml";
      flake = false;
    };

    base16-schemes = {
      url = "github:base16-project/base16-schemes";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awsvpnclient = {
      url = "github:ymatsiuk/awsvpnclient";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    hive,
    fenix,
    ...
  } @ inputs: let
    # I don't need to worry about name collisions.
    # If you think you might, don't do this.
    collect = hive.collect // {renamer = cell: target: "${target}";};
    lib = inputs.nixpkgs.lib // builtins;
  in
    hive.growOn
    {
      inherit inputs;

      cellsFrom = ./cells;
      cellBlocks = with hive.blockTypes; [
        {
          name = "configProfiles";
          type = "functions";
        }
        # library
        {
          name = "lib";
          type = "functions";
        }

        # profiles
        {
          name = "hardwareProfiles";
          type = "functions";
        }
        {
          name = "nixosProfiles";
          type = "functions";
        }
        {
          name = "homeProfiles";
          type = "functions";
        }

        # suites
        {
          name = "nixosSuites";
          type = "functions";
        }
        {
          name = "homeSuites";
          type = "functions";
        }

        # configurations
        nixosConfigurations
        colmenaConfigurations

        # pkgs
        {
          name = "pkgs";
          type = "pkgs";
        }

        # devshells
        {
          name = "devshells";
          type = "devshells";
        }
      ];

      # To keep proprietary software to a minimum:
      # allowUnfreePredicate
      # Forces us to keep track of proprietary software.
      nixpkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
          "electron-25.9.0"
          "electron-21.4.0"
          "electron-12.2.3"
          "qtwebkit-5.212.0-alpha4"
        ];
      };
    }
    {
      lib = hive.pick self ["system" "lib"];
      devShells = hive.harvest self ["system" "devshells"];
    }
    {
      nixosConfigurations = collect self "nixosConfigurations";
      colmenaHive = collect self "colmenaConfigurations";
      # TODO: implement
      # nixosModules = collect self "nixosModules";
      # hmModules = collect self "homeModules";
    };
}
