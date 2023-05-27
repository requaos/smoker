{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  programs = {
    vscode = {
      enable = true;

      userSettings = cell.lib.mkForce {};

      # References: https://github.com/hanleym/digga/blob/req/pkgs/default.nix
      # we'll sort this out after we add gui packages, lol.
      #   extensions =
      #     (
      #       nixpkgs.vscode-utils.extensionsFromVscodeMarketplace nixpkgs.generatedCodeMarketplaceExtensions
      #     )
      #     ++ [
      #       nixpkgs.vscode-extensions.rust-lang.rust-analyzer-nightly
      #     ];
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
  };
}
