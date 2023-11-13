{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  name = "cody";
  fakeDir = "/tmp/.mount_${name}";
  appimageSource = inputs.nixpkgs.fetchzip {
    url = "https://github.com/sourcegraph/sourcegraph/releases/download/app-v2023.9.22%2B1398.91e4161d32/cody_2023.9.22+1398.91e4161d32_amd64.AppImage.tar.gz";
    #url = "https://sourcegraph.com/.api/app/latest?arch=x86_64&target=linux";
    hash = "sha256-JLEWlLcNWKQPhBz+F6+XCuP4/LQPpOyIy3/frEHzpEI=";
  };
  # Raw AppImage extracted contents:
  #appimageContents = inputs.nixpkgs.appimageTools.extract {
  #  inherit name;
  #  src = "${appimageSource}/cody_2023.9.22+1398.91e4161d32_amd64.AppImage";
  #};
  cody = inputs.nixpkgs.appimageTools.wrapType2 {
    inherit name;
    src = "${appimageSource}/cody_2023.9.22+1398.91e4161d32_amd64.AppImage";
    extraPkgs = pkgs:
      with inputs.nixpkgs; [
        libthai
      ];
    meta = with inputs.nixpkgs.lib; {
      description = "Cody AI App from SourceGraph";
      homepage = "https://github.com/sourcegraph/app";
      license = licenses.asl20;
      maintainers = with maintainers; [extends];
      platforms = ["x86_64-linux"];
    };
  };
in {
  programs.fuse.userAllowOther = true;
  environment.systemPackages = with nixpkgs; [
    cody
  ];
}
