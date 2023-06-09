{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;

  mod = "Mod1";
  fonts = {
    names = ["Hack Nerd Font"];
    size = 12.0;
  };
in {
  services.betterlockscreen = {
    enable = true;
    arguments = ["--off" "5"];
    # inactiveInterval = 10;
  };
  services.clipmenu = {
    enable = true;
  };
  # TODO: compton?
  services.picom.enable = true;
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    # package = nixpkgs.i3-gaps;
    config = {
      inherit fonts;
      modifier = mod;
      #menu = "rofi";

      terminal = "alacritty";

      # pressing the current workspace keybind will return to previous workspace
      # workspaceAutoBackAndForth = true;
      workspaceLayout = "tabbed";

      startup = [
        # { command = "systemctl --user restart polybar"; always = true; notification = false; }
        # { command = "dropbox start"; notification = false; }
        # { command = "firefox"; workspace = "1: web"; }
      ];

      # assings = {
      #   "1: web" = [{ class = "^Firefox$"; }];
      #   "0: extra" = [{ class = "^Firefox$"; window_role = "About"; }];
      # };
      # output."*".bg = "${stylix.image} fill";

      bars = [
        {
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = fonts // {size = 10.0;};
          position = "bottom";
          # height = "16";
          # status_padding = 0;
        }
      ];

      # colors = {
      #   inherit background;
      #   urgent = {
      #     inherit background indicator text;
      #     border = urgent;
      #     childBorder = urgent;
      #   };
      #   focused = {
      #     inherit indicator text;
      #     background = focused;
      #     border = focused;
      #     childBorder = focused;
      #   };
      #   focusedInactive = {
      #     inherit background indicator text;
      #     border = unfocused;
      #     childBorder = unfocused;
      #   };
      #   unfocused = {
      #     inherit background indicator text;
      #     border = unfocused;
      #     childBorder = unfocused;
      #   };
      #   placeholder = {
      #     inherit background indicator text;
      #     border = unfocused;
      #     childBorder = unfocused;
      #   };
      # };

      keybindings = lib.mkOptionDefault {
        #"${mod}+Return" = "exec ${nixpkgs.alacritty}/bin/alacritty";
        "${mod}+space" = "exec ${nixpkgs.rofi}/bin/rofi -show drun";
        #"${mod}+l" = "exec sh -c '${nixpkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
        "${mod}+l" = "exec ${nixpkgs.betterlockscreen}/bin/betterlockscreen --lock --off 5";
        "Mod4+l" = "exec ${nixpkgs.betterlockscreen}/bin/betterlockscreen --lock --off 5";
        # TODO: migrate to https://github.com/lgmys/savr soon?
        "${mod}+x" = "exec sh -c '${nixpkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";

        # Screenshots
        "Print" = ''exec --no-startup-id maim --format=png | xclip -selection clipboard -t image/png'';
        "${mod}+Print" = ''exec --no-startup-id maim --window $(xdotool getactivewindow) --format=png | xclip -selection clipboard -t image/png'';
        "${mod}+Shift+Print" = ''exec --no-startup-id maim --select --format=png | xclip -selection clipboard -t image/png'';
        "${mod}+Shift+q" = "kill";

        # Applications
        "Mod4+f" = ''[class="(?i)^firefox$"] focus'';
        "Mod4+c" = ''[class="(?i)^vscodium$"] focus'';
        "Mod4+d" = ''[class="(?i)^discord$"] focus'';
        "Mod4+n" = ''[class="(?i)^notion"] focus'';
        "Mod4+t" = ''[class="(?i)^alacritty$"] focus'';
        "Mod4+a" = ''[class="(?i)^alacritty$"] focus'';

        # Focus
        "${mod}+Up" = "focus up";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Down" = "focus down";

        # Move
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Shift+Down" = "move down";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+w" = "layout tabbed";

        # Move Workspace
        # "${mod}+Control+Shift+Up" = "move up";
        # "${mod}+Control+Shift+Down" = "move down";
        "${mod}+Control+Shift+Left" = "move workspace to output left";
        "${mod}+Control+Shift+Right" = "move workspace to output right";
      };
    };
  };
}
