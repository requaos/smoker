{...}: {
  users.users.req = {
    initialHashedPassword = "$y$j9T$WKj3UyDIuS1i5jl8u62Gm0$trGjHf0T4ob87gdP.qQvwKIjCND.r8ckCdupE1yLgy8";
    isNormalUser = true;
    createHome = true;
    extraGroups = ["libvirtd" "networkmanager" "wheel" "docker"];
  };
}
