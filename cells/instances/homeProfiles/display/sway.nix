{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;

  mod = "Mod1";
  fonts = {
    names = ["Hack Nerd Font"];
    size = lib.mkForce 11.0;
  };
in {
  home.packages = with nixpkgs; [
    # swaylock # lockscreen
    # swayidle # idle screen locker
    wl-clipboard # clipboard stdout/stdin integration
    mako
    # wofi
    # waybar
    grim # screenshots
    slurp # region selection
  ];
  # programs.swaylock.settings = { };
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    wrapperFeatures.gtk = true;
    xwayland = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = {
      inherit fonts;
      modifier = mod;
      #menu = "rofi";
      terminal = "alacritty";
      # pressing the current workspace keybind will return to previous workspace
      # workspaceAutoBackAndForth = true;
      workspaceLayout = "tabbed";
      input = {
        "*" = {
          accel_profile = "flat";
        };
      };
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
          fonts = fonts // {size = lib.mkForce 10.0;};
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
          position = "bottom";
          # height = "16";
          # status_padding = 0;
        }
      ];
      # colors = lib.mkForce {
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
      keybindings = let
        makeGrimCommand = cmd: ''exec sh -c '${nixpkgs.grim}/bin/grim ${cmd} - | ${saveAndCopyScreenshot}';'';
        saveAndCopyScreenshot = ''tee "$(xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d_%H-%M-%S.png')" | wl-copy'';
        currentWindowRect = ''$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')'';
      in
        lib.mkOptionDefault {
          #"${mod}+Return" = "exec ${nixpkgs.alacritty}/bin/alacritty";
          "${mod}+space" = "exec ${nixpkgs.rofi}/bin/rofi -show drun";
          "${mod}+l" = "exec ${nixpkgs.swaylock}/bin/swaylock";
          "Mod4+l" = "exec ${nixpkgs.swaylock}/bin/swaylock";
          # TODO: migrate to https://github.com/lgmys/savr soon?
          # "${mod}+x" = "exec sh -c '${nixpkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          # "Mod4+Shift+3" = ''${nixpkgs.grim}/bin/grim'';
          # "Mod4+Shift+4" = ''exec sh -c "${nixpkgs.grim}/bin/grim -g '$(${nixpkgs.slurp}/bin/slurp)'"'';
          "Mod4+Shift+3" = ''exec sh -c "${nixpkgs.grim}/bin/grim - | ${saveAndCopyScreenshot}"'';
          "Mod4+Shift+4" = ''exec sh -c "${nixpkgs.grim}/bin/grim -g '$(${nixpkgs.slurp}/bin/slurp)' - | ${saveAndCopyScreenshot}"'';
          "Mod4+Shift+5" = ''exec sh -c "${nixpkgs.grim}/bin/grim -g '${currentWindowRect}' - | ${saveAndCopyScreenshot}"'';
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
