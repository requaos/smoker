{ inputs, cell, }:
let
  inherit (inputs) nixpkgs;
  name = "cody";
  fakeDir = "/tmp/.mount_${name}";
  appimageSource = inputs.nixpkgs.fetchzip {
    url = "https://github.com/sourcegraph/sourcegraph/releases/download/app-v2023.7.11%2B1384.7d20a90ce7/cody_2023.7.11%2B1384.7d20a90ce7_amd64.AppImage.tar.gz";
    #url = "https://sourcegraph.com/.api/app/latest?arch=x86_64&target=linux";
    hash = "sha256-PLytWmf5EtsEL4nJbezoR3G19HHJF4HHj8Da1VYAUvY=";
  };
  # Raw AppImage extracted contents:
  #appimageContents = inputs.nixpkgs.appimageTools.extract { 
  #  inherit name;
  #  src = "${appimageSource}/cody_2023.7.11+1384.7d20a90ce7_amd64.AppImage";
  #};
  cody-app = inputs.nixpkgs.appimageTools.wrapType2 {
    inherit name;
    src = "${appimageSource}/cody_2023.7.11+1384.7d20a90ce7_amd64.AppImage";
    extraPkgs = pkgs: with inputs.nixpkgs; [
      libthai
    ];
    meta = with inputs.nixpkgs.lib; {
      description = "Cody AI App from SourceGraph";
      homepage = "https://github.com/sourcegraph/app";
      license = licenses.asl20;
      maintainers = with maintainers; [ extends ];
      platforms = [ "x86_64-linux" ];
    };
  };
  cody = inputs.nixpkgs.writeShellScriptBin "cody" ''
    mkdir -p ${fakeDir}
    ${inputs.nixpkgs.bindfs}/bin/bindfs ${cody-app} ${fakeDir}
    ${fakeDir}/bin/cody
    sleep 0.3
    umount ${fakeDir}
    rmdir ${fakeDir}
  '';
in
{
  programs.fuse.userAllowOther = true;
  environment.systemPackages = with nixpkgs; [
    cody
  ];
}
