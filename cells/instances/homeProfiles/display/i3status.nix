{
  inputs,
  cell,
}:
with cell.lib.lists; let
  inherit (inputs) nixpkgs base16-schemes;
  inherit (cell) lib;

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
  home.packages = with nixpkgs; [
    neofetch
    #zenith
    htop
    nethogs
    baobab
  ];

  programs.i3status-rust = {
    enable = true;
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
              name = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink";
              format = " $icon $output_name {$volume|MUTED} ";
              click = [
                {
                  button = "left";
                  cmd = ''qpwgraph'';
                }
              ];
              step_width = 5;
              max_vol = 120;
              headphones_indicator = true;
              mappings = {
                "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink" = "💻";
                "alsa_output.pci-0000_01_00.1.hdmi-stereo" = "📺";
                "alsa_output.usb-DisplayLink_USB3.0_5K_Graphic_Docking_4310338626955-02.analog-stereo" = "🖥️";
              };
            }
            {
              block = "sound";
              name = "alsa_output.pci-0000_01_00.1.hdmi-stereo";
              format = " $icon $output_name {$volume|MUTED} ";
              click = [
                {
                  button = "left";
                  cmd = ''qpwgraph'';
                }
              ];
              step_width = 5;
              max_vol = 120;
              headphones_indicator = true;
              mappings = {
                "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink" = "💻";
                "alsa_output.pci-0000_01_00.1.hdmi-stereo" = "📺";
                "alsa_output.usb-DisplayLink_USB3.0_5K_Graphic_Docking_4310338626955-02.analog-stereo" = "🖥️";
              };
            }
            {
              block = "sound";
              name = "alsa_output.usb-DisplayLink_USB3.0_5K_Graphic_Docking_4310338626955-02.analog-stereo";
              format = " $icon $output_name {$volume|MUTED} ";
              click = [
                {
                  button = "left";
                  cmd = ''qpwgraph'';
                }
              ];
              step_width = 5;
              max_vol = 120;
              headphones_indicator = true;
              mappings = {
                "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink" = "💻";
                "alsa_output.pci-0000_01_00.1.hdmi-stereo" = "📺";
                "alsa_output.usb-DisplayLink_USB3.0_5K_Graphic_Docking_4310338626955-02.analog-stereo" = "🖥️";
              };
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
