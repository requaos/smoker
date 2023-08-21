{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs nix-vscode-extensions;
  # TODO: get $system
  extensions = nix-vscode-extensions.extensions.x86_64-linux;
in {
  vscode = {
    enable = true;

    #userSettings = cell.lib.mkForce {};

    extensions =
      /*
        (with extensions.open-vsx; [
        jnoortheen.nix-ide
        antyos.openscad
        bierner.markdown-mermaid
        bpruitt-goddard.mermaid-markdown-syntax-highlighting
        christian-kohler.path-intellisense
        gruntfuggly.todo-tree
        kamadorueda.alejandra
        mhutchie.git-graph
        mkhl.direnv
        moshfeu.compare-folders
        pkief.material-icon-theme
        serayuzgur.crates
        sourcegraph.cody-ai
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
        zhuangtongfa.material-theme
        hashicorp.terraform
      ])
      ++
      */
      with extensions.vscode-marketplace; [
        # put these back after open-vsx comes back online
        jnoortheen.nix-ide
        bierner.markdown-mermaid
        bpruitt-goddard.mermaid-markdown-syntax-highlighting
        christian-kohler.path-intellisense
        kamadorueda.alejandra
        mhutchie.git-graph
        mkhl.direnv
        moshfeu.compare-folders
        pkief.material-icon-theme
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
        zhuangtongfa.material-theme
        hashicorp.terraform

        joaompinto.vscode-graphviz
        thenuprojectcontributors.vscode-nushell-lang
      ];
  };
  starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[❯](bold purple)";
        vicmd_symbol = "[❮](bold purple)";
      };
      directory.style = "cyan";
      docker_context.symbol = " ";
      git_branch = {
        format = ''[$symbol$branch]($style) '';
        style = "bold dimmed white";
      };
      git_status = {
        format = ''([「$all_status$ahead_behind」]($style) )'';
        conflicted = "⚠";
        ahead = "⟫$count";
        behind = "⟪$count";
        diverged = "🔀";
        stashed = "↪";
        modified = "𝚫";
        staged = "✔";
        renamed = "⇆";
        deleted = "✘";
        style = "bold bright-white";
      };
      haskell.symbol = " ";
      hg_branch.symbol = " ";
      memory_usage = {
        symbol = " ";
        disabled = false;
      };
      nix_shell = {
        format = ''[$symbol$state]($style) '';
        pure_msg = "λ";
        impure_msg = "⎔";
      };
      nodejs.symbol = " ";
      package.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";
      status.disabled = false;
    };
  };
}
