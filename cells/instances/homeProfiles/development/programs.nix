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

    profiles.default.extensions =
      (with extensions.open-vsx; [
        jnoortheen.nix-ide
        antyos.openscad
        bierner.markdown-mermaid
        bpruitt-goddard.mermaid-markdown-syntax-highlighting
        christian-kohler.path-intellisense
        gruntfuggly.todo-tree
        kamadorueda.alejandra
        # mhutchie.git-graph
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
        hashicorp.terraform

        thenuprojectcontributors.vscode-nushell-lang
      ]);
  };
  nushell = {
    enable = true;
    configFile = {
      source = ./config.nu;
    };
    # envFile = {
    #   source = ./env.nu;
    # };
    package = nixpkgs.nushell;
    extraEnv = ''
      plugin add ${nixpkgs.nushellPlugins.polars}/bin/nu_plugin_polars
      # plugin add {nixpkgs.nushellPlugins.net}/bin/nu_plugin_net # seems to come from unstable and not 24.05
      plugin add ${nixpkgs.nushellPlugins.query}/bin/nu_plugin_query
      plugin add ${nixpkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat
      plugin add ${nixpkgs.nushellPlugins.formats}/bin/nu_plugin_formats
    '';
  };
  direnv.enableNushellIntegration = true;
  starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      character = {
        success_symbol = "[❯](bold purple)";
        error_symbol = "[❯](bold red)";
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
      add_newline = true;
    };
  };
  # atuin = {
  #   enable = true;
  #   enableBashIntegration = true;
  # };
}
