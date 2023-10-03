{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell.configProfiles) username domain;
  lib = inputs.nixpkgs.lib // builtins;

  dnsPort = 53;

  package = with nixpkgs; rustPlatform.buildRustPackage rec {
    pname = "trust-dns";
    version = "0.23.0";

    src = fetchFromGitHub {
      owner = "bluejekyll";
      repo = "trust-dns";
      rev = "v${version}";
      sha256 = "sha256-CfFEhZEk1Z7VG0n8EvyQwHvZIOEES5GKpm5tMeqhRVY=";
    };
    cargoHash = "sha256-jmow/jtdbuKFovXWA5xbgM67iJmkwP35hiOivIJ5JdM=";

    # buildNoDefaultFeatures = true;
    buildFeatures = [ "resolver" "dns-over-rustls" "dns-over-https-rustls" ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    # tests expect internet connectivity to query real nameservers like 8.8.8.8
    doCheck = false;

    meta = with lib; {
      description = "A Rust based DNS client, server, and resolver";
      homepage = "https://trust-dns.org/";
      maintainers = with maintainers; [ colinsane ];
      platforms = platforms.linux;
      license = with licenses; [ asl20 mit ];
    };
  };
in
{
  trust-dns = {
    enable = true;
    package = package;
    # debug = true;
    settings = {
      listen_port = dnsPort;
      listen_addrs_ipv4 = [ "0.0.0.0" ];
      listen_addrs_ipv6 = [ ];
      # directory = "/var/lib/trust-dns";
      zones = [
        {
          zone_type = "Primary";
          zone = "${domain}";
          file = nixpkgs.writeText "${domain}.zone" ''
            @ IN SOA ${domain}. root.${domain}. (
                    199609203 ; serial
                    8h        ; refresh
                    120m      ; retry
                    7d        ; expire
                    24h       ; minimum
                  )
            @          A     185.199.108.153
                       A     185.199.109.153
                       A     185.199.110.153
                       A     185.199.111.153
                       AAAA  2606:50c0:8000::153
                       AAAA  2606:50c0:8001::153
                       AAAA  2606:50c0:8002::153
                       AAAA  2606:50c0:8003::153
            www        CNAME ${username}.github.io
            *          A     192.168.1.2
            teleport   A     65.32.55.119
            *.teleport A     65.32.55.119
          '';
        }
        {
          zone_type = "Forward";
          zone = ".";
          stores = {
            type = "forward";
            name_servers = [
              {
                protocol = "tls";
                socket_addr = "1.1.1.1:853";
                tls_dns_name = "cloudflare-dns.com";
                # trust_negative_responses = true;
              }
              {
                protocol = "tls";
                socket_addr = "1.0.0.1:853";
                tls_dns_name = "cloudflare-dns.com";
                # trust_negative_responses = true;
              }
              # {
              #   protocol = "tls";
              #   socket_addr = "2606:4700:4700::1111:853";
              #   tls_dns_name = "cloudflare-dns.com";
              #   trust_negative_responses = false;
              # }
              # {
              #   protocol = "tls";
              #   socket_addr = "2606:4700:4700::1001:853";
              #   tls_dns_name = "cloudflare-dns.com";
              #   trust_negative_responses = false;
              # }
            ];
          };
        }
      ];
    };
  };
}
