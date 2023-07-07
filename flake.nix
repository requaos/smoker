{
  description = "Required Professionals NixOS Configurations";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    blank.url = "github:divnix/blank";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = {
    self,
    hive,
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
      cellBlocks = with hive.blockTypes; [
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
        allowUnfreePredicate = pkg:
          lib.elem (lib.getName pkg) [
            "zoom"
            "slack"
            "clion"
            "vscode"
            "discord"
            "obsidian"
            "libsciter"
            "nvidia-x11"
            "cudatoolkit"
            "ivsc-firmware"
            "google-chrome"
            "nvidia-settings"
            "ipu6ep-camera-bin"
            "ivsc-firmware-unstable"
            "libfprint-2-tod1-goodix"
            "ipu6ep-camera-bin-unstable"
            "notion-app-enhanced-v2.0.18"
          ];
        permittedInsecurePackages = [
          "openssl-1.1.1u"
          "electron-21.4.0"
        ];
      };
    } {
      lib = hive.pick self ["system" "lib"];
      devShells = hive.harvest self ["system" "devshells"];
    } {
      nixosConfigurations = collect self "nixosConfigurations";
      colmenaHive = collect self "colmenaConfigurations";
      # TODO: implement
      # nixosModules = collect self "nixosModules";
      # hmModules = collect self "homeModules";
    };
}
