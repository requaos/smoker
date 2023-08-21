{
  inputs,
  cell,
}: let
  inherit (cell) nixosSuites nixosProfiles homeSuites homeProfiles;

  bee = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
  time.timeZone = "America/New_York";
in
  cell.lib.mkNixosConfigurations cell {
    babybox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; babybox;

      home-manager = {
        users.req = {
          imports = with homeSuites; thin;
          home.stateVersion = "23.11";
        };
      };
      system.stateVersion = "23.11";
    };

    teeniebox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; teeniebox;

      home-manager = {
        users.req = {
          imports = with homeSuites; thick;
          home.stateVersion = "23.11";
        };
      };
      system.stateVersion = "23.11";
    };

    buukobox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; buukobox;

      home-manager = {
        users.req = {
          imports = with homeSuites; thick;
          home.stateVersion = "23.11";
        };
      };
      system.stateVersion = "23.11";
    };

    nixvmbox = {
      inherit bee time;
      imports = with nixosSuites;
      with nixosProfiles; nixvmbox;

      home-manager = {
        users.req = {
          imports = with homeSuites; thin;
          home.stateVersion = "23.11";
        };
      };
      system.stateVersion = "23.11";
    };
  }
