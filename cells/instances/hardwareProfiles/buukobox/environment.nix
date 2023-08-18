{
  inputs,
  cell,
}: {
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  # audio crackles fix
  etc = let
    json = inputs.nixpkgs.formats.json {};
  in {
    "pipewire/pipewire.conf.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context = {
        properties = {
          default.clock.rate = 4800;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
    "pipewire/pipewire-pulse.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context = {
        modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
      };
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };
  };
}
