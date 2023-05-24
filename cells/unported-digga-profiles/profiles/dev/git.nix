{
  config,
  lib,
  pkgs,
  ...
}: let
  homeDirectory = config.home-manager.users.${config.vars.username}.home.homeDirectory;
in {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      github-desktop
    ];

    # TODO: use this?
    programs.lazygit.enable = true;

    programs.git = {
      enable = true;

      userName = config.vars.fullname;
      userEmail = config.vars.email;

      aliases = {
        # deletes all merged branches
        #clean = "!sh -c 'git for-each-ref --format '%(refname:short)' --merged=origin/master --merged=origin/main refs/heads/ | xargs git branch -d'";
        cb = "rev-parse --abbrev-ref HEAD";
        publish = "!git push -u origin $(git cb):${config.vars.username}/$(git cb)";
        pub = "!git push -u origin $(git cb):${config.vars.username}/$(git cb)";
        tree = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %s %C(dim white)- %an (%ar)%C(reset)%C(bold magenta)%d%C(reset)' --all";
        sync = "!sh -c 'git checkout --quiet --detach HEAD && git fetch --prune origin master:master && git fetch --prune origin staging:staging && git fetch --prune origin dev:dev && git checkout --quiet -'";

        # logging
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";

        # delete merged branches
        bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
      };

      extraConfig = {
        core = {
          excludesfile = "${homeDirectory}/.gitignore";
          attributesfile = "${homeDirectory}/.gitattributes";
          autocrlf = "input";
        };
        pull = {
          # https://blog.sffc.xyz/post/185195398930/why-you-should-use-git-pull-ff-only-git-is-a
          #rebase = "true";
          ff = "only";
        };
        push = {
          autoSetupRemote = "true";
        };
      };
    };

    home.file.".gitignore".text = config.vars.ignoredFiles;

    home.file.".gitattributes".text = ''
      Cargo.lock -diff
      flake.lock -diff
    '';
  };
}
