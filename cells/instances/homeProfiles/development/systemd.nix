{
  inputs,
  cell,
}: {
  user = {
    services = {
      aws-rotate-key = {
        Unit = {
          Description = "aws-rotate-key oneshot";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${inputs.nixpkgs.aws-rotate-key}/bin/aws-rotate-key -y -d";
          Restart = "on-failure";
          RestartSec = "5m";
        };
      };
    };
    
    timers = {
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