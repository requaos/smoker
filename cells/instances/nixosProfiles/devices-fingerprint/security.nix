{
  inputs,
  config,
  cell,
}: let
  lib = inputs.nixpkgs.lib // builtins;
in {
  # Just turn fprintAuth on for all pam services.
  pam.services =
    lib.attrsets.genAttrs [
      "sudo"
      "i3lock"
      "lightdm"
      "login"
      "xscreensaver"
      "swaylock"
      "gdm"
    ]
    (name: {fprintAuth = lib.mkDefault true;});
}
# {
#   pam.services = {
#     sudo.fprintAuth = true;
#     i3lock.fprintAuth = true;
#     lightdm.fprintAuth = true;
#     login.fprintAuth = true;
#     xscreensaver.fprintAuth = true;
#     swaylock.fprintAuth = true;
#     gdm.fprintAuth = true;
#   };
# }

