{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  teeniebox = load ./teeniebox;
  buukobox = load ./buukobox;
}
