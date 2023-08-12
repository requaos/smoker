{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  wrappers = with nixpkgs; {
    cdrdao = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cdrdao}/bin/cdrdao";
    };
    cdrecord = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cdrtools}/bin/cdrecord";
    };
  };
}
