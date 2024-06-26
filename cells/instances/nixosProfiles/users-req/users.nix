{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.configProfiles) username fullname;
in {
  users.${username} = {
    initialHashedPassword = "$y$j9T$WKj3UyDIuS1i5jl8u62Gm0$trGjHf0T4ob87gdP.qQvwKIjCND.r8ckCdupE1yLgy8";
    description = fullname;
    isNormalUser = true;
    createHome = true;
    extraGroups = ["wheel"];

    # default shell
    useDefaultShell = false;
    shell = nixpkgs.nushell;
  };
}
