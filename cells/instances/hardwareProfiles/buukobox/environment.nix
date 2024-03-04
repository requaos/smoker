{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    linuxPackages_latest.nvidiabl
  ];
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
