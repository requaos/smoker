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

  coredns = {
    enable = true;
    config = ''
      . {
        errors
        forward . tls://1.1.1.1 1.1.1.1 {
          tls_servername cloudflare-dns.com
          health_check 5s
        }
      }
      requaos.com {
        errors
        log
        file /etc/coredns/requaos.com.db
      }
    '';
  };

  # Service that makes Out of Memory Killer more effective
  earlyoom.enable = true;
}
