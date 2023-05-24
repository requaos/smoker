{
  inputs,
  cell,
}: let
  inherit (cell) nixosSuites nixosProfiles homeSuites homeProfiles;

  bee = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
  time.timeZone = "America/New_York";
in
  cell.lib.mkNixosConfigurations cell {
    teeniebox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles;
        teeniebox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites;
            req;
          home.stateVersion = "22.11";
        };
      };

      boot.loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };

      fileSystems = {
        "/boot/efi" = {
          label = "BOOT";
          fsType = "vfat";
        };

        "/" = {
          label = "MAIN";
          fsType = "btrfs";
          options = ["subvol=/@"];
        };

        "/home" = {
          label = "MAIN";
          fsType = "btrfs";
          options = ["subvol=/@home"];
        };

        "/swap" = {
          label = "MAIN";
          fsType = "btrfs";
          options = ["subvol=/@swap"];
        };
      };

      swapDevices = [{device = "/swap/swapfile";}];

      system.stateVersion = "22.11";
    };
  }