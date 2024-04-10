{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      source $(blesh-share)/ble.sh
    '';
  };
}
