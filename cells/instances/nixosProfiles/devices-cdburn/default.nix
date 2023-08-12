{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [
    cdrkit
    cdrdao
    libsForQt5.k3b
  ];
  security.wrappers = with nixpkgs; {
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
