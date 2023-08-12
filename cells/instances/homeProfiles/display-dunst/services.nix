{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;
in {
  dunst = {
    enable = true;
    settings = {
      global = {
        font = lib.mkForce "Hack Nerd Font";
        follow = "mouse";
        enable_posix_regex = true;
        #geometry = "300x5-30+50";

        width = "(0,300)";
        height = "200";
        #notification_limit = ;
        origin = "top-right";
        offset = "32x32";
        #scale = "";
        progress_bar = true;
        transparency = 10;
      };
      # urgency_normal = {
      # 	background = "#37474f";
      # 	foreground = "#eceff1";
      # 	timeout = 10;
      # };
    };
  };
}
