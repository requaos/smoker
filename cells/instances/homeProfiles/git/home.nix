{
  inputs,
  cell,
}: {
    packages = with inputs.nixpkgs; [
      github-desktop
    ];
    
    file = {
        ".gitignore".text = ''
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

        ".gitattributes".text = ''
          Cargo.lock -diff
          flake.lock -diff
        '';
    };
}