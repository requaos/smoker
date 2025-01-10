{
  config,
  inputs,
  cell,
}: {
  variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2 -Dawt.useSystemAAFontSettings=lcd";
  };
}
