{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  # For rage encryption, all hosts need a ssh key pair
  openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };

  # Service that makes Out of Memory Killer more effective
  earlyoom.enable = true;
}
