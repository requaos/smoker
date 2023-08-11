{
  inputs,
  cell,
}: {
  #greetd = {
  #  enable = true;
  #  settings = {
  #    default_session = {
  #      command = "${inputs.nixpkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
  #      user = "greeter";
  #    };
  #  };
  #};
  xserver = {
    displayManager = {
      lightdm = {
        greeters = {
          slick = {
            enable = true;
          };
          gtk = {
            enable = false;
          };
        };
      };
    };
  };
}
