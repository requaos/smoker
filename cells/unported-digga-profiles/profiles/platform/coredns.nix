{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  networking.nameservers = ["127.0.0.1"];
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

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

  environment.etc."coredns/requaos.com.db" = {
    text = ''
      $ORIGIN requaos.com.
      @	3600 IN	SOA sns.dns.icann.org. noc.dns.icann.org. (
              2017042745 ; serial
              7200       ; refresh (2 hours)
              3600       ; retry (1 hour)
              1209600    ; expire (2 weeks)
              3600       ; minimum (1 hour)
              )

        3600 IN NS a.iana-servers.net.
        3600 IN NS b.iana-servers.net.
      @       IN A     192.168.1.2
      www     IN A     192.168.1.2
      *       IN A     192.168.1.2
      teleport IN A 65.32.55.119
      *.teleport IN A 65.32.55.119
    '';
  };
}
