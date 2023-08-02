{
  inputs,
  cell,
}: {
  greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${inputs.nixpkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
  xserver = {
    displayManager = {
      lightdm = {
        greeters = {
          gtk = {
            theme = {
              name = "SolArc-Dark";
              package = inputs.nixpkgs.solarc-gtk-theme;
            };
            indicators = [
              "~host"
              "~spacer"
              "~clock"
              "~spacer"
              "~session"
              "~language"
              "~power"
            ];
          };
        };
      };
    };
  };
}
