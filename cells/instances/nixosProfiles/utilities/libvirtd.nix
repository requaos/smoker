{
  inputs,
  cell,
}:
with cell.lib; let
  inherit (inputs) nixpkgs;

  bridgeName = "br0";
  hostInterface = "wlp0s20f3";
  infiniteLeaseTime = true;
in {
  environment = {
    systemPackages = with nixpkgs; [
      virt-manager
    ];
  };

  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemu = {
      package = nixpkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (nixpkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };

    docker = {
      autoPrune.enable = true;
    };
  };

  # libvirt uses 192.168.122.0
  networking = {
    #useNetworkd = true;
    bridges."${bridgeName}".interfaces = [];
    interfaces."${bridgeName}" = {
      ipv4.addresses = [
        {
          address = "192.168.122.1";
          prefixLength = 24;
        }
      ];
    };
    nat = {
      enable = true;
      internalInterfaces = [bridgeName];
      externalInterface = hostInterface;
      extraCommands = "iptables -t nat -A POSTROUTING -o ${hostInterface} -j MASQUERADE";
    };
  };

  # Deprecated way, hopefully the systemd.network settings below suffice
  # Seems to be the only way that works for now...
  services.dhcpd4 = {
    enable = true;
    interfaces = [bridgeName];
    extraConfig = ''
      option routers 192.168.122.1;
      option broadcast-address 192.168.122.255;
      option subnet-mask 255.255.255.0;
      option domain-name-servers 1.1.1.1, 8.8.8.8, 208.67.222.222, 1.0.0.1, 8.8.4.4, 208.67.220.220;
      ${optionalString infiniteLeaseTime ''
        default-lease-time -1;
        max-lease-time -1;
      ''}
      subnet 192.168.122.0 netmask 255.255.255.0 {
        range 192.168.122.100 192.168.122.200;
      }
    '';
  };

  # systemd.network = {
  #   netdevs = {
  #     # Create the bridge interface
  #     "20-${bridgeName}" = {
  #       netdevConfig = {
  #         Kind = "bridge";
  #         Name = bridgeName;
  #       };
  #     };
  #   };
  #   networks = {
  #     # Connect the bridge ports to the bridge
  #     "30-${hostInterface}" = {
  #       matchConfig.Name = hostInterface;
  #       networkConfig.Bridge = bridgeName;
  #       linkConfig.RequiredForOnline = "enslaved";
  #     };
  #     # Configure the bridge for its desired function
  #     "40-${bridgeName}" = {
  #       matchConfig.Name = bridgeName;
  #       address = [
  #         # configure addresses including subnet mask
  #         "192.168.122.1/24"
  #       ];
  #       networkConfig = {
  #         # start a DHCP Client for IPv4 Addressing/Routing
  #         DHCP = mkForce "ipv4";
  #       };
  #       bridgeConfig = {};
  #       linkConfig = {
  #         # or "routable" with IP addresses configured
  #         RequiredForOnline = "carrier";
  #       };
  #     };
  #   };
  # };
}
