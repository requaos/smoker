{...}: let
  username = "req";
  emailuser = "reqpro";
  domain = "requaos.com";
  fullname = "Neil Skinner";
in {
  users.users.${username} = {
    initialHashedPassword = "$y$j9T$WKj3UyDIuS1i5jl8u62Gm0$trGjHf0T4ob87gdP.qQvwKIjCND.r8ckCdupE1yLgy8";
    description = fullname;
    isNormalUser = true;
    createHome = true;
    extraGroups = ["libvirtd" "networkmanager" "wheel" "docker"];
  };

  home-manager.users.${username} = {
    programs = {
      git = {
        userName = fullname;
        userEmail = "${emailuser}@${domain}";
      };
    };
  };

  services = {
    coredns.config = ''
      . {
        errors
        forward . tls://1.1.1.1 1.1.1.1 {
          tls_servername cloudflare-dns.com
          health_check 5s
        }
      }
      ${domain} {
        errors
        log
        file /etc/coredns/${domain}.db
      }
    '';
    signald = {
      user = "req";
    };
  };

  environment = {
    etc."coredns/${domain}.db" = {
      text = ''
        $ORIGIN ${domain}.
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
  };
}
