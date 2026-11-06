{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  # graphify — https://github.com/Graphify-Labs/graphify (Apache-2.0), built
  # from the v0.9.103 release tag. nixpkgs' python3Packages carries only part
  # of the tree-sitter grammar set it needs; the missing grammars are built
  # from the PyPI sdists at the exact versions pinned in upstream's uv.lock
  # (tree-sitter-php 0.24.1 ships wheels only, so it comes from the prebuilt
  # cp310-abi3 manylinux wheel instead of an sdist).
  graphify = let
    py = nixpkgs.python3Packages;

    # several grammar sdists ship without the tree-sitter runtime headers
    # (they expect them from the runtime); vendor any that are missing.
    # parser.h must match the grammar's generated ABI: v0.24.7 for
    # LANGUAGE_VERSION 14, v0.25.2 for 15 (the python tree-sitter 0.25.2
    # runtime loads both); alloc.h/array.h are identical in both.
    parserHByAbi = {
      "14" = nixpkgs.fetchurl {
        url = "https://raw.githubusercontent.com/tree-sitter/tree-sitter/v0.24.7/lib/src/parser.h";
        hash = "sha256-ofbvFh+69IoOEPypDvUpCgYkYrMHs4mKpWKZOFO5+Ao=";
      };
      "15" = nixpkgs.fetchurl {
        url = "https://raw.githubusercontent.com/tree-sitter/tree-sitter/v0.25.2/lib/src/parser.h";
        hash = "sha256-EbZU+7p3cLHHEMwUsWm+LetdicD4cjPUYFA3wmwf9lc=";
      };
    };
    runtimeAllocH = nixpkgs.fetchurl {
      url = "https://raw.githubusercontent.com/tree-sitter/tree-sitter/v0.25.2/lib/src/alloc.h";
      hash = "sha256-KtfMU5G+gEP/3MERubIbd2f1knkPyDiay2/O5/0ay2E=";
    };
    runtimeArrayH = nixpkgs.fetchurl {
      url = "https://raw.githubusercontent.com/tree-sitter/tree-sitter/v0.25.2/lib/src/array.h";
      hash = "sha256-LuE1AAlmCi3V0Rb56WRNKA8XA+8ce0YNnUan897hyBY=";
    };
    runtimeTsAssertH = nixpkgs.fetchurl {
      url = "https://raw.githubusercontent.com/tree-sitter/tree-sitter/v0.25.2/lib/src/ts_assert.h";
      hash = "sha256-rB7Et7o4ip2HCP7rbFx2ayknzs/W22RLk5dy4dwIZSY=";
    };

    grammar = {
      pname,
      version,
      url,
      hash,
      abi ? 14,
      scanner ? null,
    }:
      py.buildPythonPackage {
        inherit pname version;
        pyproject = true;
        src = nixpkgs.fetchurl {inherit url hash;};
        build-system = [py.setuptools];
        preBuild =
          ''
            mkdir -p src/tree_sitter
            hdr() {
              if [ ! -f "src/tree_sitter/$1.h" ] && ! [ -f "tree_sitter/$1.h" ]; then
                cp "$2" "src/tree_sitter/$1.h"
              fi
            }
            hdr parser ${parserHByAbi.${toString abi}}
            hdr alloc ${runtimeAllocH}
            hdr array ${runtimeArrayH}
            hdr ts_assert ${runtimeTsAssertH}
          ''
          + nixpkgs.lib.optionalString (scanner != null) ''
            # the sdist is missing this file; its setup.py compiles it when present
            cp ${scanner} src/scanner.c
          ''
          + ''
            # several grammar scanners call assert() without including
            # <assert.h>; gcc >= 14 rejects that as an implicit declaration
            if [ -f src/scanner.c ] && grep -qE 'assert *\(' src/scanner.c && ! grep -q '#include <assert.h>' src/scanner.c; then
              sed -i '1i #include <assert.h>' src/scanner.c
            fi
          '';
        # no pythonImportsCheck here: scanner-bearing grammars reference
        # runtime allocator symbols (ts_malloc & co) that only resolve once
        # the tree_sitter runtime module is loaded in the same process, so a
        # standalone import always fails; the real verification is a parse
        # smoke test through the assembled python env below
        doCheck = false;
      };
    # falkordb client is not in nixpkgs; pure python, pinned to the uv.lock
    # version, redis dep matches nixpkgs' redis exactly
    falkordb = py.buildPythonPackage {
      pname = "falkordb";
      version = "1.8.0";
      pyproject = true;
      src = nixpkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/96/a2f4d214a0c8871e72d0fdb80b5e7caf93037ff8583d1c4e822c4344bd17/falkordb-1.8.0.tar.gz";
        hash = "sha256-01CPQ7oe4lhdHMoG5w0TOeqLD4JLUGvXAQwrVjsEauE=";
      };
      build-system = [py.hatchling];
      propagatedBuildInputs = with py; [redis python-dateutil];
      doCheck = false;
      dontUsePytestCheck = true;
    };
  in
    py.python.withPackages (_: [
      (py.buildPythonPackage {
        # pypi project name is "graphifyy" (double y); the CLI it installs is
        # still spelled "graphify"
        pname = "graphifyy";
        version = "0.9.103";
        pyproject = true;
        src = nixpkgs.fetchFromGitHub {
          owner = "Graphify-Labs";
          repo = "graphify";
          tag = "v0.9.103";
          hash = "sha256-xiM8Ne6a0ONF5ebLcmZIQuyQBmzvDzTRwxBhxEz+XDw=";
        };
        build-system = [py.setuptools];
        patches = [
          # fork commit "feat(platforms): add zcode and dsh platform skill
          # targets" (mpython77/graphify ac94a47d): ships graphify/skill-zcode.md
          # (+dsh) and its references/ bundles on top of the v0.9.103 release
          (nixpkgs.fetchpatch {
            url = "https://github.com/mpython77/graphify/commit/ac94a47d194735ec868afd4d68b9ecab2ff9452f.patch";
            hash = "sha256-ebUZHbgQzxKjWjyIVAF0cAYK7hM3ImLdPbBgc6Xk6co=";
          })
        ];
        postPatch = ''
          # the fork commit only wires the skill GENERATOR (tools/skillgen);
          # register zcode in install.py's runtime platform table so
          # `graphify install --platform zcode` resolves its skill bundle.
          # zcode user skills live at ~/.zcode/skills/<name>/SKILL.md
          substituteInPlace graphify/install.py \
            --replace-fail '    "codex": {' '    "zcode": {
        "skill_file": "skill-zcode.md",
        "skill_dst": Path(".zcode") / "skills" / "graphify" / "SKILL.md",
        "claude_md": False,
        "skill_refs": "zcode",
    },
    "codex": {'
          # setuptools package-data enumerates each skill-*.md file; add the
          # two new ones so they ship in the wheel
          substituteInPlace pyproject.toml \
            --replace-fail '"skill-devin.md", "skills' '"skill-devin.md", "skill-zcode.md", "skill-dsh.md", "skills'
        '';
        propagatedBuildInputs =
          (with py; [
            networkx
            numpy
            rapidfuzz
            pyyaml
            tree-sitter
            # grammars already provided by nixpkgs
            tree-sitter-bash
            tree-sitter-c-sharp
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-typescript
            # mcp extra (graphify-mcp / serve.py)
            mcp
            starlette
            anyio
            # pdf extra
            pypdf
            markdownify
            # svg extra; pillow: graphify floors >=13 on py>=3.11 but that
            # floor is about wheel availability — its py<3.11 floor is 12.3.0,
            # the version nixpkgs ships and matplotlib links against
            matplotlib
            pillow
            # db extras: neo4j, falkordb (added below), postgres
            neo4j
            psycopg
            # --postgres reconstructs DDL via the sql grammar
            tree-sitter-sql
          ])
          ++ [falkordb]
          ++ (map grammar [
            {
              pname = "tree-sitter-c";
              url = "https://files.pythonhosted.org/packages/a6/c9/3834f3d9278251aea7312274971bc4c45b17aec2490fd4b884d93bd7019a/tree_sitter_c-0.24.2.tar.gz";
              version = "0.24.2";
              hash = "sha256-FihYTfApm1o0CqY/jme2yXyRUX9S+n56TFV+QK2zMKk=";
            }
            {
              pname = "tree-sitter-cpp";
              url = "https://files.pythonhosted.org/packages/20/2c/4dd63d705a8933543cad9b92ff31be849b164fec91a6eb63475ebc9ce668/tree_sitter_cpp-0.23.4.tar.gz";
              version = "0.23.4";
              hash = "sha256-alnEzrsa0dwujVhs+KcrOdIbgQi3sTnQiXGegaM55B0=";
            }
            {
              pname = "tree-sitter-go";
              url = "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz";
              version = "0.25.0";
              hash = "sha256-p0Zum42U3alMro2RYp8m7bLSYWb9RU1IMcO/bfoujWg=";
            }
            {
              pname = "tree-sitter-groovy";
              url = "https://files.pythonhosted.org/packages/e8/1f/400d296618ea95932e6a3d299eababda0d138f4b0cfeaacdf50601c40ca9/tree_sitter_groovy-0.1.2.tar.gz";
              version = "0.1.2";
              hash = "sha256-SbAExK6UbT8BpgLzJc2JlkI+A05bOtNvw0odHkKvqNo=";
            }
            {
              pname = "tree-sitter-java";
              url = "https://files.pythonhosted.org/packages/fa/dc/eb9c8f96304e5d8ae1663126d89967a622a80937ad2909903569ccb7ec8f/tree_sitter_java-0.23.5.tar.gz";
              version = "0.23.5";
              hash = "sha256-9c1XuPEnCn8EOIeHUNAszHlCHUXMpl/yhPFSfp7wLjg=";
            }
            {
              pname = "tree-sitter-julia";
              url = "https://files.pythonhosted.org/packages/d5/e7/1ff7d38967471f13b77420cdfc58ce170c8ceb83ff4b55ce50744c076e79/tree_sitter_julia-0.23.1.tar.gz";
              version = "0.23.1";
              hash = "sha256-B2B8T8kCsh5oIWIvVrCKojIbkh/gZE4qtKuhdH5siAg=";
            }
            {
              pname = "tree-sitter-kotlin";
              url = "https://files.pythonhosted.org/packages/58/bb/bdab3665eeca21246130eec79c76e42456cfa72d59606266ecdbf37f9a96/tree_sitter_kotlin-1.1.0.tar.gz";
              version = "1.1.0";
              hash = "sha256-Mio1va514lrmTa5gJ75gnFQi+rKCCEEXgWxOvNphaNo=";
            }
            {
              pname = "tree-sitter-elixir";
              url = "https://files.pythonhosted.org/packages/e8/83/0501ee426bcd40cf5f765ce66ff2e7136d438ff4e65aeb08991f9826d4e5/tree_sitter_elixir-0.3.5.tar.gz";
              version = "0.3.5";
              hash = "sha256-6tCJOTsc5zIwTmtvsLwKt54ylWY9aXvgJb1J8PNnt00=";
            }
            {
              pname = "tree-sitter-objc";
              url = "https://files.pythonhosted.org/packages/d6/f2/f979251e2100753160fcee515bc36ee60997c2e79d166232c93bc6519e02/tree_sitter_objc-3.0.2.tar.gz";
              version = "3.0.2";
              hash = "sha256-rFWu/opPPqbx2iouBTcqTzcQAAGTTjaoHg+WxMYlKAk=";
            }
            {
              pname = "tree-sitter-fortran";
              url = "https://files.pythonhosted.org/packages/4b/a1/491e2b0264fa30939975309d94dff00dc00ab445a7d8d5ee30476c888a44/tree_sitter_fortran-0.6.0.tar.gz";
              version = "0.6.0";
              hash = "sha256-Zf6lQBSK5DEzWzkgJn3/rusVfvKyHAcWeYx1H2qeGTs=";
            }
            {
              pname = "tree-sitter-lua";
              url = "https://files.pythonhosted.org/packages/94/07/98d7c5f60c9a79a1d40f85e59b7c25a0102d2eebcc5a83608c7c308edf22/tree_sitter_lua-0.5.0.tar.gz";
              version = "0.5.0";
              hash = "sha256-DkY1YDjMuM4QSSiRBMViMAA0SDCaM18uNT8e3Hs3NVI=";
              # the 0.5.0 sdist is missing src/scanner.c (upstream packaging
              # bug); vendor it from the repo at the same tag
              scanner = nixpkgs.fetchurl {
                url = "https://raw.githubusercontent.com/tree-sitter-grammars/tree-sitter-lua/v0.5.0/src/scanner.c";
                hash = "sha256-NbvWMLWnQh1G0ukRhe7qCb94Vl1Ey2drY8og0PG1S70=";
              };
            }
            {
              pname = "tree-sitter-powershell";
              url = "https://files.pythonhosted.org/packages/05/59/e1806757895926cec99a71a73ac5252add3dd739c34b3e21b60f74182cbd/tree_sitter_powershell-0.26.4.tar.gz";
              version = "0.26.4";
              hash = "sha256-/8f3UmQg/jNct4gjs4vIsMJ0U+uXTKYFZ3nkz+//pgU=";
              # the 0.26.4 sdist is missing src/scanner.c; vendor it from the
              # grammar repo at the same tag
              scanner = nixpkgs.fetchurl {
                url = "https://raw.githubusercontent.com/airbus-cert/tree-sitter-powershell/v0.26.4/src/scanner.c";
                hash = "sha256-zzZrcOJYoKwesmSsD0FlyPDBuUPRpunbnSkcbPF4Ih8=";
              };
            }
            {
              pname = "tree-sitter-ruby";
              url = "https://files.pythonhosted.org/packages/09/5b/6d24be4fde4743481bd8e3fd24b434870cb6612238c8544b71fe129ed850/tree_sitter_ruby-0.23.1.tar.gz";
              version = "0.23.1";
              hash = "sha256-iG7SAL/R88p2KL8cn+/UJCG726cMYnNjq9pn9mLKoh4=";
            }
            {
              pname = "tree-sitter-scala";
              url = "https://files.pythonhosted.org/packages/eb/6a/a0943e330a926dee64b440dd7957687f8a494fcb77e1df39643324a94ce3/tree_sitter_scala-0.26.3.tar.gz";
              version = "0.26.3";
              hash = "sha256-4IuOgcPlKSOaASPSNP2qNPHi8atn1gNJJOx0GQpF5aM=";
              abi = 15;
            }
            {
              pname = "tree-sitter-swift";
              url = "https://files.pythonhosted.org/packages/f2/98/8265b5ee5f590654935742d89c187460deb867411307680e1ed7cb39979a/tree_sitter_swift-0.7.4.tar.gz";
              version = "0.7.4";
              hash = "sha256-Fnao7gREKZO4TCOSkdWXa4I9ItJbAs/FFhob1kSzkPU=";
            }
            {
              pname = "tree-sitter-verilog";
              url = "https://files.pythonhosted.org/packages/d1/b6/9b3b72c3478caa07c346550c66c6e77759c76785c82d1dd5408230e58e45/tree_sitter_verilog-1.0.3.tar.gz";
              version = "1.0.3";
              hash = "sha256-1AQ8ulDhuoQCOW4xBuF951XIbsoxGyOrgm4BjqmBiYQ=";
            }
            {
              pname = "tree-sitter-zig";
              url = "https://files.pythonhosted.org/packages/5c/97/75967b81460e0ce999de4736b9ac189dcd5ad1c85aabcc398ba529f4838e/tree_sitter_zig-1.1.2.tar.gz";
              version = "1.1.2";
              hash = "sha256-2iTbFt+S9/z6NESOBqFLY3sf+YX3zi7hkYPEieGHqS4=";
            }
          ])
          ++ [
            # tree-sitter-php 0.24.1 ships wheels only: use the prebuilt
            # cp310-abi3 manylinux wheel instead of an sdist
            (py.buildPythonPackage {
              pname = "tree-sitter-php";
              version = "0.24.1";
              format = "wheel";
              src = nixpkgs.fetchurl {
                url = "https://files.pythonhosted.org/packages/9a/c6/fd863a7a779d0ab67688939eba0e08bff7b1ffe731288d3d3610df21217b/tree_sitter_php-0.24.1-cp310-abi3-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
                hash = "sha256-ehQEow8pckmKzgQLAClzi42sRdChKTLMuLYF65S6++Q=";
              };
              doCheck = false;
              pythonImportsCheck = ["tree_sitter_php"];
            })
          ];
        doCheck = false;
        dontUsePytestCheck = true;
        pythonImportsCheck = ["graphify"];
        meta = {
          description = "Turn any codebase into a queryable knowledge graph via tree-sitter AST parsing";
          homepage = "https://github.com/Graphify-Labs/graphify";
          license = nixpkgs.lib.licenses.asl20;
        };
      })
    ]);

  # Dark neon-green faceted polygon terrain on black.
  # Source: https://wallhaven.cc/w/39mjxd (3840x2160 PNG)
  wallpaper = inputs.self + "/assets/wallpapers/teeniebox.png";

  # xfdesktop keeps one backdrop property set per monitor and workspace, and
  # monitor names are only known at runtime, so discover them from the live
  # xfconf channel rather than hardcoding a monitor name.
  setWallpaper = nixpkgs.writeShellScript "teeniebox-set-wallpaper" ''
    # only manage the background of the auto-login desktop user
    [ "$(id -un)" = "nixos" ] || exit 0

    xfconfQuery="${nixpkgs.xfconf}/bin/xfconf-query"
    channel="xfce4-desktop"

    # on a fresh account xfdesktop has not populated the backdrop channel yet
    props=""
    for _ in $(seq 1 30); do
      props="$($xfconfQuery -c "$channel" -l 2>/dev/null | grep 'last-image$' || true)"
      [ -n "$props" ] && break
      sleep 1
    done

    for prop in $props; do
      $xfconfQuery -c "$channel" -p "$prop" -s "${wallpaper}"
      # image-style 5 = zoomed: fill the screen while keeping the aspect ratio
      $xfconfQuery -c "$channel" -p "''${prop%last-image}image-style" --create -t int -s 5
    done
  '';
in {
  variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2 -Dawt.useSystemAAFontSettings=lcd";
  };
  systemPackages = with nixpkgs; [
    mesa
    vulkan-tools # use vkcube to test if vulkan is working properly
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
    libvdpau-va-gl
    virglrenderer
    xdg-desktop-portal-wlr
    v4l2-relayd

    # full nodejs (not nodejs-slim): slim omits npm/npx/corepack
    nodejs

    graphify

    inputs.llm-agents.packages.${nixpkgs.stdenv.hostPlatform.system}.zcode
  ];

  etc."xdg/autostart/teeniebox-wallpaper.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Set Desktop Background
    Exec=${setWallpaper}
    OnlyShowIn=XFCE;
    Terminal=false
    NoDisplay=true
  '';
}
