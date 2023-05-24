{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      aws-rotate-key
    ];

    systemd.user.services = {
      aws-rotate-key = {
        Unit = {
          Description = "aws-rotate-key oneshot";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.aws-rotate-key}/bin/aws-rotate-key -y -d";
          Restart = "on-failure";
          RestartSec = "5m";
        };
      };
    };

    systemd.user.timers = {
      aws-rotate-key = {
        Unit = {
          Description = "aws-rotate-key weekly";
        };
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
