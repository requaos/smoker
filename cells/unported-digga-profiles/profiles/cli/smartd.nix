{
  config,
  pkgs,
  lib,
  ...
}: {
  services.smartd = {
    enable = true;
    autodetect = true;
    # devices = [];
    defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04)";
    notifications = {
      wall.enable = true;
      mail = {
        enable = true;
        # mailer = "/run/wrappers/bin/sendmail";
        sender = config.vars.email;
        recipient = config.vars.email;
      };
      # test = true;
    };
  };
}
