{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs base16-schemes;
  inherit (cell) lib;

  home-manager = inputs.home-manager.nixosModules.home-manager;

  fromYaml = import "${inputs.from-yaml}/fromYaml.nix" {lib = nixpkgs.lib;};

  colors = fromYaml (builtins.readFile "${base16-schemes}/onedark.yaml");

  mod = "Mod1";
  background = colors.base00; #base01???
  indicator = colors.base0B; # what is this? it's green...
  text = colors.base05;
  urgent = colors.base08;
  unfocused = colors.base02; #base03;
  focused = colors.base02; #base0A;

  openWithTerminal = cmd: ''alacritty --command ${cmd}'';
  openWithFileManager = path: ''dbus-send --session --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowFolders array:string:"file://${path}" string:""'';
  openWithStorageViewer = path: ''baobab ${path}'';
  nethogsPath = "/run/wrappers/bin/nethogs";
in {
  i18n.defaultLocale = "en_US.utf8";

  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-intel
  ];

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

  services = {
    fwupd = {
      enable = true;
    };
    thermald = {
      enable = true;
    };
    fstrim = {
      enable = true;
    };
  };
  environment = {
    systemPackages = with inputs.nixpkgs; [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-good

      # broken until https://github.com/NixOS/nixpkgs/pull/244378 is merged in.
      #gst_all_1.icamerasrc-ipu6ep

      mesa
      vulkan-tools # use vkcube to test if vulkan is working properly
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      virglrenderer
      xdg-desktop-portal-wlr
    ];
  };
  console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      {
        programs.i3status-rust = {
          bars = {
            default = {
              # theme = "modern";
              # icons = "awesome6";
              settings = {
                theme = {
                  theme = "plain"; # plain | semi-native | native
                };
                icons = {
                  icons = "material-nf";
                };
              };
              blocks =
                [
                  {
                    block = "custom";
                    command = "cat /etc/hostname";
                    interval = "once";
                  }
                  {
                    block = "custom";
                    command = "echo `uname` `uname -r | tr - . | cut -d. -f1-3`";
                    interval = "once";
                  }
                  {
                    block = "cpu";
                    interval = 5;
                    click = [
                      {
                        button = "left";
                        cmd = openWithTerminal "htop --sort-key=PERCENT_CPU";
                      }
                    ];
                  }
                  {
                    block = "memory";
                    format = " $icon $mem_used_percents ";
                    interval = 5;
                    click = [
                      {
                        button = "left";
                        cmd = openWithTerminal "htop --sort-key=PERCENT_MEM";
                      }
                    ];
                  }
                  {
                    block = "net";
                    device = "wlp3s0";
                    icons_format = "{icon}";
                    format = " ^icon_net_down $speed_down.eng(prefix:K) / ^icon_net_up $speed_up.eng(prefix:K) ";
                    interval = 30;
                    click = [
                      {
                        button = "left";
                        cmd = openWithTerminal "sudo ${nethogsPath}";
                      }
                    ];
                    icons_overrides = {
                      net_wired = "";
                    };
                  }
                ]
                ++ (
                  forEach [
                    "/"
                  ]
                  (path: {
                    inherit path;
                    block = "disk_space";
                    format = " $icon $percentage ";
                    info_type = "used";
                    alert = 90;
                    warning = 75;
                    interval = 60;
                    click = [
                      {
                        button = "left";
                        cmd = openWithFileManager "${path}";
                      }
                      {
                        button = "right";
                        cmd = openWithStorageViewer "${path}";
                      }
                    ];
                  })
                )
                ++ [
                  # https://github.com/greshake/i3status-rust/blob/v0.22.0/doc/blocks.md#music
                  # {
                  #   block = "music";
                  # }
                  {
                    block = "backlight";
                    format = " $icon $brightness";
                    # hide this block if no backlight controls available
                    missing_format = "";
                  }
                  {
                    block = "sound";
                    format = " $icon {$volume|MUTED} ";
                    click = [
                      {
                        button = "left";
                        cmd = ''qpwgraph'';
                      }
                    ];
                    step_width = 5;
                    max_vol = 120;
                    headphones_indicator = true;
                  }
                  {
                    block = "sound";
                    device_kind = "source";
                    format = " $icon {$volume|MUTED} ";
                    click = [
                      {
                        button = "left";
                        cmd = ''qpwgraph'';
                      }
                    ];
                    step_width = 5;
                    max_vol = 120;
                  }
                  {
                    block = "battery";
                    format = " $icon $percentage {$time |}";
                    # hide this block if no battery on system
                    missing_format = "";
                  }
                  {
                    block = "time";
                    format = " $timestamp.datetime(f:'%a %-m/%d/%Y %-I:%M %p') ";
                    interval = 60;
                  }
                ];
            };
          };
        };
      }
    ];
  };
}
