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

  mkDirenvShell = pkgs.writeShellApplication {
    name = "mk-direnv-shell";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      set -euo pipefail

      template_root="${templateStorePath}"

      show_usage() {
        cat <<'EOF'
Usage: mk-direnv-shell [--force]

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
            show_usage
            exit 0
            ;;
          *)
            printf 'mk-direnv-shell: unknown option %s\n' "$1" >&2
            show_usage >&2
            exit 1
            ;;
        esac
      done

      copy_template() {
        local name="$1"
        local src="''${template_root}/''${name}"
        local dest="''${PWD}/''${name}"

        if [ -e "$dest" ] && [ "$force" -ne 1 ]; then
          printf 'mk-direnv-shell: %s already exists (use --force to overwrite)\n' "$dest" >&2
          exit 1
        fi

        cp "$src" "$dest"
      }

      copy_template ".envrc"
      copy_template "shell.nix"

      printf 'mk-direnv-shell: wrote .envrc and shell.nix in %s\n' "$PWD"
    '';
  };
in
{
  home.packages = [ mkDirenvShell ];

  home.file.".local/share/nix-templates/${templateName}/.envrc".source =
    ./templates/direnv-shell/.envrc;

  home.file.".local/share/nix-templates/${templateName}/shell.nix".source =
    ./templates/direnv-shell/shell.nix;
}
