{
  config,
  lib,
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [hplip];
  };
}
