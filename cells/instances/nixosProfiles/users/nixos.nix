{pkgs, ...}: {
  users.users.nixos = {
    initialHashedPassword = "";
    isNormalUser = true;
    createHome = true;
  };
}