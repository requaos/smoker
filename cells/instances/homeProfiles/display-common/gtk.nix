{
  inputs,
  cell,
}: {
  enable = true;
  iconTheme = {
    name = "elementary-Xfce-dark";
    package = inputs.nixpkgs.elementary-xfce-icon-theme;
  };
  theme = {
    name = "zukitre-dark";
    package = inputs.nixpkgs.zuki-themes;
  };
  gtk3.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };
  gtk4.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };
}
