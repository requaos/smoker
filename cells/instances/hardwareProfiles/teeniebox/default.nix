{
  inputs,
  cell,
}: {
  i18n.defaultLocale = "en_US.utf8";

  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-intel
  ];

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
    fwupd = {
      enable = true;
    };
    thermald = {
      enable = true;
    };
    fstrim = {
      enable = true;
    };
    fprintd = {
      tod = {
        enable = true;
        driver = inputs.nixpkgs.libfprint-2-tod1-goodix;
      };
    };
  };
  environment = {
    variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
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

      # fprintd-tod == fprintd /w (T)ouch (O)EM (D)rivers
      fprintd-tod
      libfprint-tod
    ];
  };
  console.font = "${inputs.nixpkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  home.programs.i3status-rust = {
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
              device = "wlp0s20f3";
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
