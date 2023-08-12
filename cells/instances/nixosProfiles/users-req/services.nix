{...}: let
  username = "req";
in {
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
}
