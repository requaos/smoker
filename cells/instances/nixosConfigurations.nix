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
      with nixosProfiles; teeniebox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "23.05";
        };
      };

      # root disk encryption
      boot = {
        initrd.luks = {
          devices = {
            "root" = {
              device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
            };
          };
        };
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 25;
          };
          efi = {
            canTouchEfiVariables = true;
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/33a1de74-fe6d-4466-be43-ce02816d1679";
          fsType = "btrfs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/FBA5-7197";
          fsType = "vfat";
        };
      };

      swapDevices = [{device = "/dev/disk/by-uuid/0ab38578-d63e-42de-b68e-a32acba18ab8";}];

      system.stateVersion = "23.05";
    };

    buukobox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; buukobox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "22.11";
        };
      };

      # root disk encryption
      boot = {
        initrd.luks = {
          devices = {
            "root" = {
              device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
            };
          };
        };
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 25;
          };
          efi = {
            canTouchEfiVariables = true;
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/33a1de74-fe6d-4466-be43-ce02816d1679";
          fsType = "btrfs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/FBA5-7197";
          fsType = "vfat";
        };
      };

      swapDevices = [{device = "/dev/disk/by-uuid/0ab38578-d63e-42de-b68e-a32acba18ab8";}];

      system.stateVersion = "22.11";
    };
  }
