{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  oci-containers.backend = "docker";
  # oci-containers.backend = "podman";

  podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = with nixpkgs; [
      #gvisor
    ];
    defaultNetwork = {
      settings = {
        dns_enabled = true;
      };
      # extraPlugins = [ ];
    };
  };
}
