{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    (python3.withPackages (ps:
      with ps; [
        (
          buildPythonPackage rec {
            pname = "unisoc-unlock";
            version = "0.0.2";
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-0aozmQ4Eb5zL4rtNHSFjEynfObUkYlid1PgMDVmRkwY=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              # Specify dependencies
              nixpkgs.python3Packages.pycryptodome
              nixpkgs.python3Packages.libusb1
            ];
          }
        )
      ]))
  ];
}