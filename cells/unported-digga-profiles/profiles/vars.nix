{
  config,
  lib,
  pkgs,
  ...
}: {
  vars = rec {
    fullname = "Neil Skinner";
    username = "req";
    domain = "requaos.com";
    email = "reqpro@requaos.com";

    ignoredFiles = ''
      .DS_Store
      .DS_Store?
      ._*
      .Spotlight-V100
      .Trashes
      ehthumbs.db
      Thumbs.db
      node_modules
      target

      .idea
      .vscode
      data
    '';
  };
}
