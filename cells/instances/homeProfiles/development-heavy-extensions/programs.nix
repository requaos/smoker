{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs nix-vscode-extensions;
  # TODO: get $system
  extensions = nix-vscode-extensions.extensions.x86_64-linux;
in {
  vscode = {
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
      (with extensions.vscode-marketplace; [
        # put these back after open-vsx comes back online
        antyos.openscad
        gruntfuggly.todo-tree
        serayuzgur.crates
        sourcegraph.cody-ai

        humao.rest-client
        jscearcy.rust-doc-viewer
        mitsuhiko.insta
        ms-vsliveshare.vsliveshare
        vscjava.vscode-java-pack
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-maven
        vscjava.vscode-java-test
        vscjava.vscode-java-dependency
      ])
      ++ [
        inputs.fenix.packages.rust-analyzer-vscode-extension
      ];
  };
}
