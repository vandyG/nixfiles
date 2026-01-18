{ config, pkgs, ... }:

let
  templateName = "direnv-shell";
  templateStorePath = pkgs.linkFarm "direnv-shell-template" [
    {
      name = ".envrc";
      path = ./templates/direnv-shell/.envrc;
    }
    {
      name = "shell.nix";
      path = ./templates/direnv-shell/shell.nix;
    }
  ];
  firefoxUserTemplatePath = ./templates/user.js;

  nixVandy = pkgs.writeShellApplication {
    name = "nix-vandy";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      set -euo pipefail

      template_root="${templateStorePath}"
      firefox_user_template="${firefoxUserTemplatePath}"

      show_usage() {
        cat <<'EOF'
Usage:
  nix-vandy <command> [options]

Commands:
  initshell   Create .envrc and shell.nix in the current directory.
  initff      Copy user.js into a Firefox profile directory.

Options:
  -h, --help   Show this help text.
EOF
      }

      if [ "$#" -lt 1 ]; then
        show_usage >&2
        exit 1
      fi

      command="$1"
      shift

      case "$command" in
        initshell)
          show_initshell_usage() {
            cat <<'EOF'
Usage: nix-vandy initshell [--force]

Creates .envrc and shell.nix in the current directory from predefined templates.

Options:
  -f, --force   Overwrite existing files.
  -h, --help    Show this help text.
EOF
          }

          force=0
          while [ "$#" -gt 0 ]; do
            case "$1" in
              -f|--force)
                force=1
                shift
                ;;
              -h|--help)
                show_initshell_usage
                exit 0
                ;;
              *)
                printf 'nix-vandy initshell: unknown option %s\n' "$1" >&2
                show_initshell_usage >&2
                exit 1
                ;;
            esac
          done

          copy_template() {
            local name="$1"
            local src="''${template_root}/''${name}"
            local dest="''${PWD}/''${name}"

            if [ -e "$dest" ] && [ "$force" -ne 1 ]; then
              printf 'nix-vandy initshell: %s already exists (use --force to overwrite)\n' "$dest" >&2
              exit 1
            fi

            cp "$src" "$dest"
          }

          copy_template ".envrc"
          copy_template "shell.nix"

          printf 'nix-vandy initshell: wrote .envrc and shell.nix in %s\n' "$PWD"
          ;;
        initff)
          show_initff_usage() {
            cat <<'EOF'
Usage: nix-vandy initff <firefox-profile-dir>

Copies user.js into the provided Firefox profile directory.

Options:
  -h, --help   Show this help text.
EOF
          }

          if [ "$#" -lt 1 ]; then
            show_initff_usage >&2
            exit 1
          fi

          if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
            show_initff_usage
            exit 0
          fi

          profile_dir="$1"
          if [ ! -d "$profile_dir" ]; then
            printf 'nix-vandy initff: directory not found: %s\n' "$profile_dir" >&2
            exit 1
          fi

          dest="''${profile_dir%/}/user.js"
          if [ -e "$dest" ]; then
            printf 'nix-vandy initff: %s already exists\n' "$dest" >&2
            exit 1
          fi

          cp "$firefox_user_template" "$dest"
          printf 'nix-vandy initff: wrote user.js in %s\n' "$profile_dir"
          ;;
        -h|--help)
          show_usage
          ;;
        *)
          printf 'nix-vandy: unknown command %s\n' "$command" >&2
          show_usage >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [ nixVandy ];

  home.file.".local/share/nix-templates/${templateName}/.envrc".source =
    ./templates/direnv-shell/.envrc;

  home.file.".local/share/nix-templates/${templateName}/shell.nix".source =
    ./templates/direnv-shell/shell.nix;
}
