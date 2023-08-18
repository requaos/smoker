{
  inputs,
  cell,
}: {
  xserver = {
    displayManager = {
      defaultSession = "i3";
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
