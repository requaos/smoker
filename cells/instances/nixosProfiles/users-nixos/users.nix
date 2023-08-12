{pkgs, ...}: {
  users.nixos = {
    initialHashedPassword = "";
    isNormalUser = true;
    createHome = true;
  };
}
