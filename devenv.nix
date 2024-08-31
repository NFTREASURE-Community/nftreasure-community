{
  pkgs,
  config,
  lib,
  ...
}: let
  packages = with pkgs; [
  ];

  devPackages = with pkgs; [
    direnv
    figlet
    git
    hugo
    jq
    yq-go
  ];
in {
  name = "nftreasure-community";

  env = {
    PROJECT = "nftreasure-community";
  };

  cachix = {
    pull = [
      "pre-commit-hooks"
      "salt-labs"
    ];
    push = [
      "salt-labs"
    ];
  };

  devenv = {
    warnOnNewVersion = true;
  };

  dotenv = {
    enable = true;
    disableHint = false;
  };

  packages =
    packages
    ++ lib.optionals (!config.container.isBuilding) devPackages;

  enterShell = ''
    figlet -f starwars -w 120 $PROJECT

    echo Hello ''${USER:-user}, welcome to the $PROJECT project
  '';

  languages = {
    nix = {
      enable = true;
    };

    shell = {
      enable = true;
    };

    go = {
      enable = true;
    };
  };

  difftastic = {
    enable = true;
  };

  pre-commit = {
    default_stages = [
      "pre-commit"
    ];

    excludes = [];

    hooks = {
      actionlint = {
        enable = true;
      };

      alejandra = {
        enable = true;
        fail_fast = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      check-json = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      check-shebang-scripts-are-executable = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      check-symlinks = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      check-yaml = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      convco = {
        enable = true;
      };

      cspell = {
        enable = false;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      deadnix = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      dialyzer = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      editorconfig-checker = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      hadolint = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      markdownlint = {
        enable = true;
        settings = {
          configuration = {
            MD013 = {
              line_length = 240;
            };
            MD033 = false;
          };
        };
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      nil = {
        enable = false;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      pre-commit-hook-ensure-sops = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      prettier = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
        settings = {
          no-bracket-spacing = true;
          print-width = 120;
          allow-parens = "always";
        };
      };

      pretty-format-json = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      ripsecrets = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      shellcheck = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      shfmt = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      staticcheck = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      trim-trailing-whitespace = {
        enable = true;
        excludes = [
          "vendor/"
          "themes/"
        ];
      };

      typos = {
        enable = true;
        excludes = [
          "_vendor/"
          "vendor/"
          "themes/"
          "static/"
        ];
      };

      yamllint = {
        enable = true;
        settings = {
          configuration = ''
            extends: relaxed
            rules:
              line-length: disable
              indentation: enable
          '';
        };
        excludes = [
          "vendor/"
          "themes/"
        ];
      };
    };
  };

  starship = {
    enable = true;
    config = {
      enable = false;
    };
  };

  devcontainer = {
    enable = true;
    settings = {
      customizations = {
        vscode = {
          extensions = [
            "arrterian.nix-env-selector"
            "esbenp.prettier-vscode"
            "exiasr.hadolint"
            "github.copilot"
            "github.copilot-chat"
            "github.vscode-github-actions"
            "golang.go"
            "gruntfuggly.todo-tree"
            "johnpapa.vscode-peacock"
            "kamadorueda.alejandra"
            "mkhl.direnv"
            "ms-azuretools.vscode-docker"
            "ms-kubernetes-tools.vscode-kubernetes-tools"
            "ms-vscode.makefile-tools"
            "nhoizey.gremlins"
            "pinage404.nix-extension-pack"
            "redhat.vscode-yaml"
            "streetsidesoftware.code-spell-checker"
            "supermaven.supermaven"
            "tekumura.typos-vscode"
            "timonwong.shellcheck"
            "tuxtina.json2yaml"
            "vscodevim.vim"
            "wakatime.vscode-wakatime"
            "yzhang.markdown-all-in-one"
          ];
        };
      };
    };
  };

  enterTest = ''
    echo "Running devenv tests..."
  '';
}
