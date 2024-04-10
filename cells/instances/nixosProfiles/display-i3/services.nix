{
  inputs,
  cell,
}: {
  displayManager.defaultSession = "i3";
  xserver = {
    displayManager = {
      session = [
        {
          name = "i3";
          manage = "desktop";
          start = ''exec $HOME/.xsession'';
        }
      ];
    };
  };
  tumbler.enable = true;
  gvfs.enable = true;
}
