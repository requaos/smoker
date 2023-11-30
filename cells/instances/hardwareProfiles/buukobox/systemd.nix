{
  inputs,
  cell,
}: {
  user.services.displaySetupOnBoot = with inputs.nixpkgs; {
    description = "Detect displays and set position, gamma and brightness";
    script = ''
      #!${bash}/bin/bash

      CONNECTED_DISPLAYS="$(${xorg.xrandr}/bin/xrandr | ${gnugrep}/bin/grep "\sconnected" | ${gawk}/bin/awk '{ print $1 }')"
      CDL=($CONNECTED_DISPLAYS)
      DOCK_LEFT="DVI-I-2-2"
      DLF="0"
      DOCK_CENTER="HDMI-0"
      DCF="0"
      DOCK_RIGHT="DVI-I-1-1"
      DRF="0"

      LOG="Connected Displays:"
      for CD in $CDL
      do
              LOG+="\n  - "
              if [ "$CD" == "$DOCK_CENTER" ]
              then
                      ${xorg.xrandr}/bin/xrandr --output HDMI-0 --brightness 1 --gamma 0.7:0.7:0.7
                      DCF="1"
                      ${xorg.xrandr}/bin/xrandr 2>&1 >/dev/null
                      LOG+="Center";
              elif [ "$CD" == "$DOCK_RIGHT" ]
              then
                      DRF="1"
                      LOG+="Right";
              elif [ "$CD" == "$DOCK_LEFT" ]
              then
                      DLF="1"
                      LOG+="Left";
              else
                      LOG+="$CD";
              fi
      done

      if [[ "$DCF" == "1" && "$DRF" == "1" ]]
      then
              LOG+="\nSetting DVI-I-1-1 to the Right"
              ${xorg.xrandr}/bin/xrandr --output DVI-I-1-1 --mode 2560x1440 --right-of HDMI-0 --auto --brightness 0.6 --gamma 0.7:0.7:0.7
              ${xorg.xrandr}/bin/xrandr 2>&1 >/dev/null;
      fi

      if [[ "$DCF" == "1" && "$DLF" == "1" ]]
      then
              LOG+="\nSetting DVI-I-2-2 to the Left"
              ${xorg.xrandr}/bin/xrandr --output DVI-I-2-2 --mode 2560x1440 --left-of HDMI-0 --auto --brightness 0.6 --gamma 0.7:0.7:0.7
              ${xorg.xrandr}/bin/xrandr 2>&1 >/dev/null;
      fi

      if [ "$DLF" == "1" ]
      then
              LOG+="\nSetting DP-4 to the Bottom"
              ${xorg.xrandr}/bin/xrandr --output DP-4 --below DVI-I-2-2 --auto --brightness 1 --gamma 0.7:0.7:0.7;
      else
              LOG+="\nSetting DP-4"
              ${xorg.xrandr}/bin/xrandr --output DP-4 --auto --brightness 1 --gamma 0.7:0.7:0.7;
      fi
      ${brightnessctl}/bin/brightnessctl --class=backlight s 40% 2>&1 >/dev/null

      printf "$LOG";
    '';
    wantedBy = ["multi-user.target"]; # starts after login
  };
}
