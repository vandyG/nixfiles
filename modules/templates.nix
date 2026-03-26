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
    runtimeInputs = [ pkgs.coreutils pkgs.git ];
    text = ''
      set -euo pipefail

      template_root="${templateStorePath}"
      firefox_user_template="${firefoxUserTemplatePath}"

      repo_git() {
        git -C "$repo_root" "$@"
      }

      ensure_nixfiles_repo() {
        repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
        if [ -z "$repo_root" ]; then
          printf 'nix-vandy syncbranches: not inside a git repository\n' >&2
          exit 1
        fi

        if [ ! -f "$repo_root/home.nix" ] || [ ! -d "$repo_root/modules" ]; then
          printf 'nix-vandy syncbranches: expected to run inside the nixfiles repository\n' >&2
          exit 1
        fi
      }

      require_clean_worktree() {
        if ! repo_git diff --quiet --ignore-submodules --; then
          printf 'nix-vandy syncbranches: working tree has unstaged changes\n' >&2
          exit 1
        fi

        if ! repo_git diff --quiet --ignore-submodules --cached; then
          printf 'nix-vandy syncbranches: index has staged changes\n' >&2
          exit 1
        fi
      }

      restore_original_branch() {
        if [ -z "''${repo_root:-}" ] || [ -z "''${original_branch:-}" ]; then
          return
        fi

        rebase_merge_path="$(repo_git rev-parse --git-path rebase-merge)"
        rebase_apply_path="$(repo_git rev-parse --git-path rebase-apply)"
        if [ -d "$rebase_merge_path" ] || [ -d "$rebase_apply_path" ]; then
          return
        fi

        current_branch="$(repo_git branch --show-current || true)"
        if [ "$current_branch" != "$original_branch" ]; then
          repo_git checkout "$original_branch" >/dev/null 2>&1 || true
        fi
      }

      show_usage() {
        cat <<'EOF'
Usage:
  nix-vandy <command> [options]

Commands:
  initshell   Create .envrc and shell.nix in the current directory.
  initff      Copy user.js into a Firefox profile directory.
  syncbranches Rebase all local branches onto master and push tracked origin branches.

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
            chmod 0644 "$dest"
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
          chmod 0644 "$dest"
          printf 'nix-vandy initff: wrote user.js in %s\n' "$profile_dir"
          ;;
        syncbranches)
          show_syncbranches_usage() {
            cat <<'EOF'
Usage: nix-vandy syncbranches

Fetches origin, fast-forwards local master to origin/master, rebases every other
local branch onto master, and force-pushes branches that track origin/* using
--force-with-lease.

Requirements:
  - Run from inside this nixfiles repository.
  - Working tree and index must be clean.
  - Current HEAD must be on a branch, not detached.
EOF
          }

          if [ "$#" -gt 0 ]; then
            if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
              show_syncbranches_usage
              exit 0
            fi

            printf 'nix-vandy syncbranches: unknown option %s\n' "$1" >&2
            show_syncbranches_usage >&2
            exit 1
          fi

          ensure_nixfiles_repo
          require_clean_worktree

          original_branch="$(repo_git branch --show-current)"
          if [ -z "$original_branch" ]; then
            printf 'nix-vandy syncbranches: detached HEAD is not supported\n' >&2
            exit 1
          fi

          trap restore_original_branch EXIT

          repo_git fetch --all --prune

          if ! repo_git show-ref --verify --quiet refs/heads/master; then
            printf 'nix-vandy syncbranches: local master branch not found\n' >&2
            exit 1
          fi

          if ! repo_git show-ref --verify --quiet refs/remotes/origin/master; then
            printf 'nix-vandy syncbranches: origin/master not found\n' >&2
            exit 1
          fi

          repo_git checkout master >/dev/null
          repo_git pull --ff-only origin master

          mapfile -t branch_entries < <(repo_git for-each-ref --format='%(refname:short)|%(upstream:short)' refs/heads)

          rebased_branches=()
          pushed_branches=()
          skipped_push_branches=()

          for branch_entry in "''${branch_entries[@]}"; do
            branch_name="''${branch_entry%%|*}"
            upstream_ref="''${branch_entry#*|}"

            if [ "$branch_name" = "master" ]; then
              continue
            fi

            repo_git checkout "$branch_name" >/dev/null
            repo_git rebase master
            rebased_branches+=("$branch_name")

            case "$upstream_ref" in
              origin/*)
                repo_git push --force-with-lease origin "$branch_name"
                pushed_branches+=("$branch_name")
                ;;
              *)
                skipped_push_branches+=("$branch_name")
                ;;
            esac
          done

          printf 'nix-vandy syncbranches: rebased %s\n' "''${rebased_branches[*]:-none}"
          if [ "''${#pushed_branches[@]}" -gt 0 ]; then
            printf 'nix-vandy syncbranches: pushed %s\n' "''${pushed_branches[*]}"
          fi
          if [ "''${#skipped_push_branches[@]}" -gt 0 ]; then
            printf 'nix-vandy syncbranches: skipped push for %s (no origin/* upstream)\n' "''${skipped_push_branches[*]}"
          fi
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

  home.file.".local/share/nix-templates/${templateName}/.envrc" = {
    source = ./templates/direnv-shell/.envrc;
  };

  home.file.".local/share/nix-templates/${templateName}/shell.nix" = {
    source = ./templates/direnv-shell/shell.nix;
  };

  home.file.".local/share/nix-templates/firefox/user.js" = {
    source = ./templates/user.js;
  };
}
