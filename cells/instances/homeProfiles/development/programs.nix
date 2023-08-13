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
      (with extensions.open-vsx; [
        antyos.openscad
        bierner.markdown-mermaid
        bpruitt-goddard.mermaid-markdown-syntax-highlighting
        christian-kohler.path-intellisense
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
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
      ])
      ++ (with extensions.vscode-marketplace; [
        joaompinto.vscode-graphviz
        jscearcy.rust-doc-viewer
        mitsuhiko.insta
        ms-vsliveshare.vsliveshare
        thenuprojectcontributors.vscode-nushell-lang
        vscjava.vscode-java-pack
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-maven
        vscjava.vscode-java-test
        vscjava.vscode-java-dependency
        hashicorp.terraform
      ])
      ++ [
        inputs.fenix.packages.rust-analyzer-vscode-extension
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
