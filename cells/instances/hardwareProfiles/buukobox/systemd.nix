{
  inputs,
  cell,
}: {
  #   user.services.displaySetupOnBoot = with inputs.nixpkgs; {
  #     description = "Detect displays and set position, gamma and brightness";
  #     path = with inputs.nixpkgs; [
  #       bash
  #       gawk
  #       gnugrep
  #       xorg.xrandr
  #       brightnessctl
  #     ];
  #     script = ''
  #       CONNECTED_DISPLAYS="$(xrandr | grep "\sconnected" | awk '{ print $1 }')"
  #       DOCK_LEFT="DP-0"
  #       DLF="0"
  #       DOCK_CENTER="HDMI-0"
  #       DCF="0"
  #       DOCK_RIGHT="DP-5"
  #       DRF="0"

  #       LOG="Connected Displays:"
  #       for CD in $CONNECTED_DISPLAYS
  #       do
  #               LOG+="\n  - "
  #               if [ "$CD" == "$DOCK_CENTER" ]
  #               then
  #                       xrandr --output HDMI-0 --brightness 1 --gamma 0.7:0.7:0.7
  #                       DCF="1"
  #                       xrandr 2>&1 >/dev/null
  #                       LOG+="Center";
  #               elif [ "$CD" == "$DOCK_RIGHT" ]
  #               then
  #                       DRF="1"
  #                       LOG+="Right";
  #               elif [ "$CD" == "$DOCK_LEFT" ]
  #               then
  #                       DLF="1"
  #                       LOG+="Left";
  #               else
  #                       LOG+="$CD";
  #               fi
  #       done

  #       if [[ "$DCF" == "1" && "$DRF" == "1" ]]
  #       then
  #               LOG+="\nSetting DP-5 to the Right"
  #               xrandr --output DP-5 --mode 2560x1440 --right-of HDMI-0 --auto --brightness 0.6 --gamma 0.7:0.7:0.7
  #               xrandr 2>&1 >/dev/null;
  #       fi

  #       if [[ "$DCF" == "1" && "$DLF" == "1" ]]
  #       then
  #               LOG+="\nSetting DP-0 to the Left"
  #               xrandr --output DP-0 --mode 2560x1440 --left-of HDMI-0 --auto --brightness 0.6 --gamma 0.7:0.7:0.7
  #               xrandr 2>&1 >/dev/null;
  #       fi

  #       if [ "$DLF" == "1" ]
  #       then
  #               LOG+="\nSetting DP-4 to the Bottom"
  #               xrandr --output DP-4 --below DP-0 --auto --brightness 1 --gamma 0.7:0.7:0.7;
  #       else
  #               LOG+="\nSetting DP-4"
  #               xrandr --output DP-4 --auto --brightness 1 --gamma 0.7:0.7:0.7;
  #       fi
  #       brightnessctl --class=backlight s 40% 2>&1 >/dev/null

  #       printf "$LOG";
  #     '';
  #     wantedBy = ["graphical-session.target"];
  #     partOf = ["graphical-session.target"];
  #   };
}
