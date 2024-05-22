{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  oci-containers.backend = "docker";
  # oci-containers.backend = "podman";

  docker = {
    enable = true;
    enableOnBoot = true;
    # enableNvidia = true;
    storageDriver = "btrfs";
    # logDriver = "journald";
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   # extraPackages = with nixpkgs; [
  #   #   gvisor
  #   # ];
  #   defaultNetwork = {
  #     settings = {
  #       dns_enabled = true;
  #     };
  #     # extraPlugins = [ ];
  #   };
  # };
}
