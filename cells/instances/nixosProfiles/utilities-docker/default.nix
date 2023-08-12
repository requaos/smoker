{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  virtualisation.oci-containers.backend = "docker";
  # virtualisation.oci-containers.backend = "podman";

  environment.systemPackages = with nixpkgs; [
    # Exclusive select here:
    docker-compose
    # podman-compose
  ];

  # virtualisation.docker = {
  #   enable = true;
  #   storageDriver = "overlay2";
  #   daemon.settings = {
  #     dns = [ "192.168.1.1" ];
  #   };
  # };
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = with nixpkgs; [
      gvisor
    ];
    defaultNetwork = {
      settings = {
        dns_enabled = true;
      };
      # extraPlugins = [ ];
    };
  };

  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   defaultNetwork.dnsname.enable = true;
  #   dockerSocket.enable = true;
  #   extraPackages = with nixpkgs; [ gvisor ];
  # };
}
