{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with lib.lists; let
  home = config.home-manager.users.${config.vars.username}.home;
  mod = "Mod1";
  background = base00; #base01???
  indicator = base0B; # what is this? it's green...
  text = base05;
  urgent = base08;
  unfocused = base02; #base03;
  focused = base02; #base0A;

  openWithTerminal = cmd: ''alacritty --command ${cmd}'';
  openWithFileManager = path: ''dbus-send --session --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowFolders array:string:"file://${path}" string:""'';
  openWithStorageViewer = path: ''baobab ${path}'';
  nethogsPath = "/etc/profiles/per-user/${config.vars.username}/bin/nethogs";
in {
  security.wrappers.nethogs = {
    source = "${pkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "root";
  };

  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      neofetch
      #zenith
      htop
      nethogs
      nvtop
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
                device = "enp7s0";
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
                block = "sound";
                device_kind = "sink";
                format = " $icon {$volume|MUTED} ";
                step_width = 5;
                max_vol = 120;
                headphones_indicator = true;
              }
              {
                block = "sound";
                device_kind = "source";
                format = " $icon {$volume|MUTED} ";
                step_width = 5;
                max_vol = 120;
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
  };
}
