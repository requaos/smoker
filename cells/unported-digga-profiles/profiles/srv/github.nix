{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.github-runner-token = {
    file = ../../secrets/github-runner-token.age;
  };

  services.github-runners = {
    rustbot = {
      enable = true;
      name = "rustbot";
      url = "https://github.com/hanleym/rustbot";
      tokenFile = config.age.secrets.github-runner-token.path;
    };
  };
}
