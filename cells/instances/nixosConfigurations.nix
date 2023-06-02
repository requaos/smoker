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
    teeniebox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; teeniebox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "22.11";
        };
      };

      system.stateVersion = "22.11";
    };
    buukobox = {
      inherit bee time;

      imports = with nixosSuites;
      with nixosProfiles; buukobox;

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.req = {
          imports = with homeSuites; req;
          home.stateVersion = "22.11";
        };
      };

      system.stateVersion = "22.11";
    };
  }
