{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    gcompris
    tuxtype
    tuxpaint
    extremetuxracer
    freedroidrpg
    superTuxKart
    superTux
  ];
}
