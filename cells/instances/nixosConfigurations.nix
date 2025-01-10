{
  inputs,
  cell,
}: let
  inherit (cell) nixosSuites nixosProfiles homeSuites homeProfiles;
  lib = inputs.nixpkgs.lib // builtins;
  bee = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
  home-manager = profile: {
    users.req = {
      imports = profile;
      home.stateVersion = "25.05";
    };
    backupFileExtension = "bckup";
  };
  time.timeZone = "America/New_York";
in
  cell.lib.mkNixosConfigurations cell {
    babybox = {
      inherit bee time;
      imports = with nixosSuites; with nixosProfiles; babybox;

      home-manager = with homeSuites; home-manager thin;
      system.stateVersion = "23.11";
    };

    teeniebox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; teeniebox;

      home-manager = with homeSuites; home-manager thick;
      system.stateVersion = "23.11";
    };

    buukobox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; buukobox;

      home-manager = with homeSuites; home-manager thick;
      system.stateVersion = "23.11";
    };

    nixvmbox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; nixvmbox;

      home-manager = with homeSuites; home-manager thin;
      system.stateVersion = "23.11";
    };
  }
