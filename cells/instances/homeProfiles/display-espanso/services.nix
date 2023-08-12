{
  inputs,
  cell,
}: {
  espanso = {
    enable = true;
    matches = {
      "META" = {
        matches = [
          {
            trigger = ":shrug";
            replace = ''¯\_(ツ)_/¯'';
          }
          {
            trigger = ":date";
            replace = ''{{output}}'';
            vars = [
              {
                name = "output";
                type = "date";
                params = {
                  format = "%Y-%m-%d";
                };
              }
            ];
          }
          {
            trigger = ":now";
            replace = ''{{output}}'';
            vars = [
              {
                name = "output";
                type = "date";
                params = {
                  format = "%Y-%m-%dT%H-%M-%S";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
