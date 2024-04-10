{
  config,
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    config.boot.kernelPackages.nvidiabl
  ];
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2 -Dawt.useSystemAAFontSettings=lcd";
  };
}
