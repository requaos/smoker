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
    babybox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; babybox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "23.05";
        };
      };

      # no disk encryption

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/0d67162c-bc3d-45b6-a4a5-cd65c2d088b1";
          fsType = "btrfs";
          options = ["subvol=@"];
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/F984-617C";
          fsType = "vfat";
        };
      };

      swapDevices = [
        {
          device = "/dev/disk/by-uuid/698fe725-bd8a-46d2-8c2d-8dfb4672067c";
        }
      ];

      system.stateVersion = "23.05";
    };

    teeniebox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; teeniebox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "23.11";
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

      system.stateVersion = "23.11";
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
              device = "/dev/disk/by-uuid/0463b269-67b8-4fd2-a9d1-a60d244ef12e";
            };
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/ffae4d62-edb8-41a5-ade9-dd371490ebd8";
          fsType = "btrfs";
          options = ["subvol=@"];
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/EA31-5359";
          fsType = "vfat";
        };
      };

      swapDevices = [];

      system.stateVersion = "22.11";
    };

    nixvmbox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; nixvmbox;

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
        initrd = {
          secrets = {
            "/crypto_keyfile.bin" = null;
          };
          luks = {
            devices = {
              "luks-88fee0a5-a601-49d5-a681-608a20ed9b87" = {
                device = "/dev/disk/by-uuid/88fee0a5-a601-49d5-a681-608a20ed9b87";
              };
            };
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/40ced919-440e-4aeb-8578-09ffc94621a0";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/CECC-FEF2";
          fsType = "vfat";
        };
      };

      swapDevices = [];

      system.stateVersion = "22.11";
    };
  }
