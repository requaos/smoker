{
  config,
  lib,
  pkgs,
  ...
}: {
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };

  users.users.${config.vars.username} = {
    extraGroups = ["scanner" "lp"];
  };
}
