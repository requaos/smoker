{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  # For rage encryption, all hosts need a ssh key pair
  openssh = {
    enable = true;
    openFirewall = lib.mkDefault true;
    startWhenNeeded = true;
    settings = {
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = true;
      X11Forwarding = true;
    };
  };
}
