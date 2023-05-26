{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  services.coredns = {
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
}