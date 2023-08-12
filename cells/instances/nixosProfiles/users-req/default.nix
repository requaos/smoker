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
    extraGroups = ["libvirtd" "networkmanager" "wheel" "docker" "cdrom"];
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
    '';
    signald = {
      user = username;
    };
  };
}
