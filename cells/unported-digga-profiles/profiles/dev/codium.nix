{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # fix for wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.users.${config.vars.username} = {
    programs.vscode = {
      enable = true;
      # swap to codium instead.
      # package = pkgs.vscodium;
      # enableUpdateCheck = false;

      userSettings = lib.mkForce {};

      # userSettings = {
      #   "files.autoSave" = "off";
      #   "[nix]"."editor.tabSize" = 2;
      # };
      # keybindings = [
      #   {
      #     key = "ctrl+c";
      #     command = "editor.action.clipboardCopyAction";
      #     when = "textInputFocus";
      #   }
      # ];
      # userTasks = {
      #   version = "2.0.0";
      #   tasks = [
      #     {
      #       type = "shell";
      #       label = "Hello task";
      #       command = "hello";
      #     }
      #   ];
      # };

      # enableExtensionUpdateCheck = false;
      # mutableExtensionsDir = false;

      extensions =
        (
          pkgs.vscode-utils.extensionsFromVscodeMarketplace pkgs.generatedCodeMarketplaceExtensions
        )
        ++ [
          pkgs.vscode-extensions.rust-lang.rust-analyzer-nightly
        ];
    };
  };
}
