{
  inputs,
  cell,
}: let
  inherit (cell) lib;
in {
  dbus.enable = true;

  gnome.gnome-keyring.enable = true;

  # Printers
  printing = {
    enable = true;
    browsing = true;
    drivers = with inputs.nixpkgs; [
      gutenprint
      hplip
      postscript-lexmark
    ];
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All

      BrowseProtocols all
    '';
  };
  avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # Service that makes Out of Memory Killer more effective
  earlyoom.enable = true;
}
