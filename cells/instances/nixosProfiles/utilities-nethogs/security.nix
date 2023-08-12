{
  inputs,
  cell,
}: {
  wrappers.nethogs = {
    source = "${inputs.nixpkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "root";
  };
}
