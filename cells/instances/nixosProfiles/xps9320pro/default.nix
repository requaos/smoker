{ cell
, config
, inputs
, ...
}:
let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;
  pkgs = nixpkgs;

  ipu6-camera-bin = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ipu6-camera-bin";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ipu6-camera-bins";
        rev = "main";
        sha256 = "sha256-zJmEwgMj21W4gWD/+PqffDr8A0qtjLFypYmcpulAz+Q=";
      };

      installPhase = ''
        mkdir -p $out/include
        mkdir -p $out/lib/pkgconfig
        cp -r $src/include/* $out/include/
        cp -r $src/lib/* $out/lib/
        cp -r $out/lib/ipu_adl/pkgconfig/* $out/lib/pkgconfig/

        for pc in $out/lib/pkgconfig/*; do
          substituteInPlace $pc \
            --replace "prefix=/usr" "prefix=$out"
          done
      '';
    };

  ivsc-firmware = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = "main";
        sha256 = "sha256-GuD1oTnDEs0HslJjXx26DkVQIe0eS+js4UoaTDa77ME=";
      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };

  ipu6-camera-hal = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ipu6-camera-hal";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ipu6-camera-hal";
        rev = "main";
        sha256 = "sha256-yS1D7o6dsQ4FQkjfwcisOxcP7Majb+4uQ/iW5anMb5c=";
      };

      nativeBuildInputs = [ cmake pkg-config ];

      cmakeFlags = [
        "-DIPU_VER=ipu6ep"
        "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
        "-DUSE_PG_LITE_PIPE=ON"
        "-DUSE_STATIC_GRAPH=OFF"
        "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
        "-DCMAKE_INSTALL_LIBDIR=lib"
        "-DCMAKE_INSTALL_INCLUDEDIR=include"
      ];

      buildInputs = [
        ipu6-camera-bin

        expat.dev
        libtool
      ];
    };

  icamerasrc = with pkgs;
    stdenv.mkDerivation rec {
      pname = "icamerasrc";
      version = "icamerasrc_slim_api";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "icamerasrc";
        rev = "icamerasrc_slim_api";
        sha256 = "sha256-GFtXbLF3DI8iZwZlb+zIRJkqgjca9AdtmIMZZARRzUc=";
      };

      nativeBuildInputs = [ automake autoconf autoreconfHook pkg-config ];

      # gstreamer cannot otherwise be found
      NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

      CHROME_SLIM_CAMHAL = "ON";
      STRIP_VIRTUAL_CHANNEL_CAMHAL = "ON";

      buildInputs = [
        ipu6-camera-bin
        ipu6-camera-hal

        expat.dev
        libtool
        gst_all_1.gstreamer.dev
        gst_all_1.gst-plugins-base.dev
        libdrm.dev
      ];
    };

  # ivsc-driver = with pkgs;
  #   stdenv.mkDerivation rec {
  #     pname = "ivsc-driver";
  #     version = "master";

  #     src = pkgs.fetchFromGitHub {
  #       owner = "intel";
  #       repo = "ivsc-driver";
  #       rev = "master";
  #       sha256 = "sha256-Q7iyKw4WFSX42E4AtoW/zYRKpknWZSU66V5VPAx6AjA=";
  #     };

  #     nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

  #     installTargets = [ "modules_install" ];

  #     makeFlags =
  #       config.boot.kernelPackages.kernel.makeFlags
  #       ++ [
  #         "KERNELRELEASE=${config.boot.kernelPackages.kernel.modDirVersion}"
  #         "KERNEL_SRC=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
  #         "INSTALL_MOD_PATH=${placeholder "out"}"
  #       ];
  #   };

  # ipu6-drivers = with pkgs;
  #   stdenv.mkDerivation rec {
  #     pname = "ipu6-drivers";
  #     version = "master";

  #     src = builtins.fetchGit {
  #       url = "https://git.launchpad.net/~vicamo/+git/intel-ipu6-dkms";
  #       rev = "93051009e7366f9d45a2f6a9d4cbbda540ec111e";
  #       ref = "ubuntu/kinetic";
  #     };

  #     nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

  #     prePatch = ''
  #       patches="$(echo debian/patches/*.patch)$(echo patches/*.patch)"
  #     '';

  #     installTargets = [ "modules_install" ];

  #     makeFlags =
  #       config.boot.kernelPackages.kernel.makeFlags
  #       ++ [
  #         "KERNELRELEASE=${config.boot.kernelPackages.kernel.modDirVersion}"
  #         "KERNEL_SRC=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
  #         "INSTALL_MOD_PATH=${placeholder "out"}"
  #       ];
  #   };

  v4l2-relayd = with pkgs;
    stdenv.mkDerivation rec {
      pname = "v4l2-relayd";
      version = "main";

      src = pkgs.fetchFromGitLab {
        owner = "vicamo";
        repo = "v4l2-relayd";
        rev = "main";
        sha256 = "sha256-PWQHbDFbuPHEfNTxA7dnfDDM1es3RaaBGjYy3FGmYss=";
      };

      nativeBuildInputs = [ automake autoconf autoreconfHook pkg-config ];

      preInstall = ''
        mkdir -p $out/lib/systemd/system $out/etc
        ${pkgs.coreutils}/bin/cp -r $src/data/etc/* $out/etc
        ${pkgs.coreutils}/bin/cp -r $src/data/systemd/* $out/lib/systemd/system
      '';

      buildInputs = [
        gst_all_1.gstreamer.dev
        gst_all_1.gst-plugins-base.dev
      ];
    };

  v4l2loopback = config.boot.kernelPackages.v4l2loopback.overrideAttrs (super: {
    src = builtins.fetchGit {
      url = "https://git.launchpad.net/ubuntu/+source/v4l2loopback";
      ref = "ubuntu/devel";
      rev = "b37d72d783e2605447858ab8bcdf80ddf5ea906a";
    };

    prePatch = ''
      patches="$(echo debian/patches/*.patch)$(echo patches/*.patch)"
    '';
  });

  webcamName = "Stupid Webcam";
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop

    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  hardware.enableAllFirmware = true;

  services.hardware.bolt.enable = true;
  services.colord.enable = true;
  services.fprintd.enable = true;

  environment.etc.camera.source = "${ipu6-camera-hal}/share/defaults/etc/camera";

  systemd.services.v4l2-relayd = {
    environment = {
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [ icamerasrc gstreamer gst-plugins-base gst-plugins-good ]);
      LD_LIBRARY_PATH = "${ipu6-camera-bin}/lib";
    };
    script = ''
      export GST_DEBUG=2
      export DEVICE=$(grep -l -m1 -E "^${webcamName}$" /sys/devices/virtual/video4linux/*/name | cut -d/ -f6);

      exec ${v4l2-relayd}/bin/v4l2-relayd \
        --debug \
        -i "icamerasrc" \
        -o "appsrc name=appsrc caps=video/x-raw,format=NV12,width=1280,height=720,framerate=30/1 ! videoconvert ! video/x-raw,format=YUY2 ! v4l2sink name=v4l2sink device=/dev/$DEVICE"
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };

  hardware.firmware = [
    ipu6-camera-bin
    ivsc-firmware
  ];

  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.ipu6-drivers
    (lib.lowPrio pkgs.linuxPackages_latest.ivsc-driver)
    v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"
    "kvm-intel"
  ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options v4l2loopback exclusive_caps=1 card_label="${webcamName}"
  '';
}
