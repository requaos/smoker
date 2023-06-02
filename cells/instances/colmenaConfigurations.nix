{
  inputs,
  cell,
}:
cell.lib.mkColmenaConfigurations
cell
{
  bee.system = "x86_64-linux";
  bee.pkgs = inputs.nixpkgs;
  deployment = {
    allowLocalDeployment = true;
    tags = ["all"];
  };
}
{
  teeniebox = {
  };
  buukobox = {
  };
}
