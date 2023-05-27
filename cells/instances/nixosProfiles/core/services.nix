{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  # Service that makes Out of Memory Killer more effective
  earlyoom.enable = true;
}
