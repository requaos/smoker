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
      ])
      ++
      (with extensions.vscode-marketplace; [
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
        hashicorp.terraform
      ])
      ++ [
        inputs.fenix.packages.rust-analyzer-vscode-extension
      ];
  };
}
