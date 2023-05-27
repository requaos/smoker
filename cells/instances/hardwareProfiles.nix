{
  inputs,
  cell,
}: {
  teeniebox = {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
    ];

    boot = {
      # bleeding-edge kernel:
      kernelPackages = inputs.nixpkgs.linuxPackages_testing;

      kernelModules = ["kvm-intel"];
      blacklistedKernelModules = ["psmouse"];
      kernelParams = [
        "i915.force_probe=46a6"
      ];
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "vmd"
          "thunderbolt"
        ];
        luks.devices."root".device = "/dev/disk/by-uuid/cc582743-c00f-457a-bea0-841a72b945ec";
      };

      # used for cross-compiling for aarch64.
      # https://github.com/nix-community/nixos-generators#cross-compiling
      binfmt.emulatedSystems = ["aarch64-linux"];

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

    i18n.defaultLocale = "en_US.utf8";

    # Display scaling
    services = {
      xserver = {
        videoDrivers = ["iris"];
        dpi = 192;
        displayManager.sessionCommands = ''
          ${inputs.nixpkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xft.dpi: 192
          EOF
        '';
      };
    };
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
    console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

    networking = {
      useDHCP = cell.lib.mkForce true;
      networkmanager = {
        enable = cell.lib.mkForce true;
      };
    };

    hardware = {
      opengl = {
        enable = true;
        extraPackages = with inputs.nixpkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;
    };
  };
}
