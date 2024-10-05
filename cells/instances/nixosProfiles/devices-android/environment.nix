{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  systemPackages = with nixpkgs; [
    (python311.withPackages (ps:
      with ps; [
        (
          buildPythonPackage rec {
            pname = "unisoc_unlock";
            version = "0.0.2";
            format = "pyproject";
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-vi4C45Xo/mWG5/ZFAz2EdRaHheUsRt37p5pj/R5rfBE=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              # Specify dependencies
              nixpkgs.python311Packages.pycryptodome
              nixpkgs.python311Packages.hatchling
              nixpkgs.python311Packages.libusb1
            ];
          }
        )
      ]))
  ];
}
