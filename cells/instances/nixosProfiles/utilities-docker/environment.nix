{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    # Exclusive select here:
    docker-compose
    # podman-compose
  ];
}
