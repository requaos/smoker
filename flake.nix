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

    #windmill = {
    #  url = "git+ssh://git@github.com/hanleym/windmill";
    #};

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.url = "github:numtide/devshell";
        # std is archived with paisano pinned at a rev whose default grow
        # systems list includes x86_64-darwin, which nixpkgs-unstable has
        # since removed from lib.systems.doubles.all. std's own (and hive's)
        # aux grow uses that default, breaking all evaluation of these libs.
        # Override to the rev that dropped x86_64-darwin (88739c8).
        paisano.url = "github:paisano-nix/core/88739c84d308876714322eb9844ede6597c1a580";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        std.follows = "std";
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

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
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
      # nixpkgs-unstable dropped x86_64-darwin from lib.systems.doubles.all,
      # which paisano uses for its System enum, so the four-system default
      # no longer validates. Everything in this repo is x86_64-linux anyway.
      systems = ["x86_64-linux"];
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
        allowBroken = true;
        permittedInsecurePackages = [
          "olm-3.2.16"
          "archiver-3.5.1"
          "openssl-1.1.1w"
          "electron-39.8.10"
          "electron-25.9.0"
          "electron-21.4.0"
          "electron-12.2.3"
          "dotnet-sdk-7.0.410"
          "jitsi-meet-1.0.8043"
          "qtwebkit-5.212.0-alpha4"
        ];
        # packageOverrides = nixpkgs: {
        #   # python312 breaks nixpkgs.hplip, etc.
        #   python3 = nixpkgs.python311;
        # };
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
