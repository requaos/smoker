{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib stdenv fetchFromGitHub buildNpmPackage;
  inherit (cell.configProfiles) loopback domain secrets;
  # lib = nixpkgs.lib // builtins;

  host = "windmill.${domain}";
  port = 7000;
  lspPort = 7001;
  #http://localhost:40189/
  #volumePath = "/var/lib/windmill";

  pname = "windmill";
  version = "1.333.1";

  src = inputs.windmill;

  # src = fetchFromGitHub {
  #   owner = "windmill-labs";
  #   repo = "windmill";
  #   rev = "v${version}";
  #   hash = "sha256-Zoz6p6ySOVV1kHuZEvZ/kS/20kivbkkbhgbUxCJ8hWw=";
  # };

  pythonEnv = nixpkgs.python3.withPackages (ps: [ps.pip-tools]);

  frontend-build = buildNpmPackage {
    inherit version src;

    pname = "windmill-ui";

    sourceRoot = "source/frontend";

    npmDepsHash = "sha256-t5ukCRN0MKBI6jpTqCHMVi3ipzqzZtLAF2Kx2esqBKk=";

    # without these you get a
    # FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    env.NODE_OPTIONS = "--max-old-space-size=8192";

    preBuild = ''
      npm run generate-backend-client
    '';

    buildInputs = with nixpkgs; [
      pixman
      cairo
      pango
      giflib
    ];

    nativeBuildInputs = with nixpkgs; [
      pkg-config
      python3
    ];

    installPhase = ''
      mkdir -p $out/share
      mv build $out/share/windmill-frontend
    '';
  };

  windmill = nixpkgs.rustPlatform.buildRustPackage {
    inherit pname version;
    src = "${src}/backend";

    env = {
      SQLX_OFFLINE = "true";
      RUSTY_V8_ARCHIVE = let
        fetch_librusty_v8 = args:
          nixpkgs.fetchurl {
            name = "librusty_v8-${args.version}";
            url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
            sha256 = args.shas.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
            meta = {inherit (args) version;};
          };
      in
        fetch_librusty_v8 {
          version = "0.83.2";
          shas = {
            x86_64-linux = "sha256-RJNdy5jRZK3dTgrHsWuZZAHUyy1EogyNNuBekZ3Arrk=";
            aarch64-linux = "";
            x86_64-darwin = "";
            aarch64-darwin = "";
          };
        };
    };

    cargoLock = {
      lockFile = "${src}/backend/Cargo.lock";
      outputHashes = {
        "archiver-rs-0.5.1" = "sha256-ZIik0mMABmhdx/ullgbOrKH5GAtqcOKq5A6vB7aBSjk=";
        "pg-embed-0.7.2" = "sha256-R/SrlzNK7aAOyXVTQ/WPkiQb6FyMg9tpsmPTsiossDY=";
        "php-parser-rs-0.1.3" = "sha256-ZeI3KgUPmtjlRfq6eAYveqt8Ay35gwj6B9iOQRjQa9A=";
        "progenitor-0.3.0" = "sha256-F6XRZFVIN6/HfcM8yI/PyNke45FL7jbcznIiqj22eIQ=";
        "rustpython-ast-0.3.1" = "sha256-q9N+z3F6YICQuUMp3a10OS792tCq0GiSSlkcaLxi3Gs=";
        "tiberius-0.12.2" = "sha256-s/S0K3hE+JNCrNVxoSCSs4myLHvukBYTwk2A5vZ7Ae8=";
        "tinyvector-0.1.0" = "sha256-NYGhofU4rh+2IAM+zwe04YQdXY8Aa4gTmn2V2HtzRfI=";
      };
    };

    patches = [
      ./swagger-cli.patch
      ./run.go.config.proto.patch
      ./run.python3.config.proto.patch
      ./run.bash.config.proto.patch
    ];

    postPatch = ''
      substituteInPlace windmill-worker/src/bash_executor.rs \
        --replace '/bin/bash' '${nixpkgs.bash}/bin/bash'

      substituteInPlace windmill-worker/src/bash_executor.rs \
        --replace '/bin/nu' '${nixpkgs.nushell}/bin/nu'

      substituteInPlace windmill-api/src/lib.rs \
        --replace 'unknown-version' 'v${version}'

      substituteInPlace src/main.rs \
        --replace 'unknown-version' 'v${version}'

      pushd ..

      mkdir -p frontend/build
      cp -R ${frontend-build}/share/windmill-frontend/* frontend/build
      cp ${src}/openflow.openapi.yaml .

      popd
    '';

    buildFeatures = [
      "enterprise"
    ];

    buildInputs = with nixpkgs; [
      openssl
      rustfmt
      lld
      stdenv.cc.cc.lib
    ];

    nativeBuildInputs = with nixpkgs; [
      pkg-config
      makeWrapper
      swagger-cli
      cmake # for libz-ng-sys crate
    ];

    # needs a postgres database running
    doCheck = false;

    postFixup = ''
      patchelf --set-rpath ${lib.makeLibraryPath [nixpkgs.openssl]} $out/bin/windmill

      wrapProgram "$out/bin/windmill" \
        --prefix PATH : ${lib.makeBinPath (with nixpkgs; [bash bun deno go nushell pythonEnv nsjail powershell])} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [stdenv.cc.cc.lib]} \
        --set BASH_PATH "${nixpkgs.bash}/bin/bash" \
        --set BUN_PATH "${nixpkgs.bun}/bin/bun" \
        --set COMPOSER_PATH "${nixpkgs.php82Packages.composer}/bin/composer" \
        --set DENO_PATH "${nixpkgs.deno}/bin/deno" \
        --set GO_PATH "${nixpkgs.go}/bin/go" \
        --set NUSHELL_PATH "${nixpkgs.nushell}/bin/nu" \
        --set NSJAIL_PATH "${nixpkgs.nsjail}/bin/nsjail" \
        --set PHP_PATH "${nixpkgs.php}/bin/php" \
        --set POWERSHELL_PATH "${nixpkgs.powershell}/bin/pwsh" \
        --set PYTHON_PATH "${pythonEnv}/bin/python3"
    '';

    meta = {
      #changelog = "https://github.com/windmill-labs/windmill/blob/${src.rev}/CHANGELOG.md";
      description = "Open-source developer platform to turn scripts into workflows and UIs";
      homepage = "https://windmill.dev";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [dit7ya happysalada];
      mainProgram = "windmill";
      # limited by librusty_v8
      platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    };
  };
in {
  disabledModules = [
    "services/web-apps/windmill.nix"
  ];
  imports = [
    ../../nixosOverrides/windmill.nix
  ];

  environment.systemPackages = [
    windmill
  ];

  # services.authelia.instances.main.settings.access_control.rules = [
  #   {
  #     domain = host;
  #     networks = ["internal"];
  #     policy = "bypass";
  #   }
  # ];

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      windmill = {
        entryPoints = ["https"];
        rule = "Host(`${host}`)";
        # middlewares = ["authelia@file"];
        service = "windmill";
      };
    };
    services = {
      windmill = {
        loadBalancer = {
          servers = [
            {
              url = "http://${loopback}:${toString port}";
            }
          ];
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["windmill"];
    ensureUsers = [
      {
        name = "windmill";
        ensureDBOwnership = true;
      }
    ];
  };

  services.windmill = {
    enable = true;
    package = windmill;
    baseUrl = "https://${host}";
    serverPort = port;
    lspPort = lspPort;
    database = {
      urlPath = secrets.windmill-database-url.path;
      createLocally = true;
      name = "windmill";
      #user = "windmill";
    };
  };
}
