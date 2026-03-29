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
    {
      name = "workspace.code-workspace";
      path = ./templates/direnv-shell/workspace.code-workspace;
    }
  ];
  firefoxUserTemplatePath = ./templates/firefox/user.js;

  nixVandy = pkgs.writeShellApplication {
    name = "nix-vandy";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
    ];
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

            run_repo_git_quiet() {
              local step="$1"
              shift

              local output_file
              output_file="$(mktemp)"

              if repo_git "$@" >"$output_file" 2>&1; then
                rm -f "$output_file"
                return 0
              fi

              printf 'nix-vandy syncbranches: %s failed\n' "$step" >&2
              cat "$output_file" >&2
              rm -f "$output_file"
              exit 1
            }

            join_branch_list() {
              if [ "$#" -eq 0 ]; then
                printf 'none'
                return
              fi

              printf '%s' "$1"
              shift
              while [ "$#" -gt 0 ]; do
                printf ', %s' "$1"
                shift
              done
            }

            show_usage() {
              cat <<'EOF'
      Usage:
        nix-vandy <command> [options]

      Commands:
        initshell   Create .envrc, shell.nix, and a VS Code workspace file in the current directory.
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

      Creates .envrc, shell.nix, and a VS Code workspace file in the current directory
      from predefined templates.

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

                copy_workspace_template() {
                  local workspace_name
                  local src="''${template_root}/workspace.code-workspace"

                  workspace_name="$(basename "$PWD").code-workspace"
                  dest="''${PWD}/''${workspace_name}"

                  if [ -e "$dest" ] && [ "$force" -ne 1 ]; then
                    printf 'nix-vandy initshell: %s already exists (use --force to overwrite)\n' "$dest" >&2
                    exit 1
                  fi

                  cp "$src" "$dest"
                  chmod 0644 "$dest"
                }

                copy_template ".envrc"
                copy_template "shell.nix"
                copy_workspace_template

                printf 'nix-vandy initshell: wrote .envrc, shell.nix, and %s in %s\n' "$(basename "$PWD").code-workspace" "$PWD"
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

                printf 'nix-vandy syncbranches\n'
                printf '  fetch   origin\n'
                run_repo_git_quiet 'fetching remotes' fetch --all --prune

                if ! repo_git show-ref --verify --quiet refs/heads/master; then
                  printf 'nix-vandy syncbranches: local master branch not found\n' >&2
                  exit 1
                fi

                if ! repo_git show-ref --verify --quiet refs/remotes/origin/master; then
                  printf 'nix-vandy syncbranches: origin/master not found\n' >&2
                  exit 1
                fi

                printf '  update  master\n'
                run_repo_git_quiet 'checking out master' checkout master
                run_repo_git_quiet 'fast-forwarding master from origin/master' pull --ff-only origin master

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

                  printf '  rebase  %s\n' "$branch_name"
                  run_repo_git_quiet "checking out $branch_name" checkout "$branch_name"
                  run_repo_git_quiet "rebasing $branch_name onto master" rebase master
                  rebased_branches+=("$branch_name")

                  case "$upstream_ref" in
                    origin/*)
                      printf '  push    %s\n' "$branch_name"
                      run_repo_git_quiet "pushing $branch_name to $upstream_ref" push --force-with-lease origin "$branch_name"
                      pushed_branches+=("$branch_name")
                      ;;
                    *)
                      printf '  skip    %s (no origin/* upstream)\n' "$branch_name"
                      skipped_push_branches+=("$branch_name")
                      ;;
                  esac
                done

                printf '  done\n'
                printf '    rebased: %s\n' "$(join_branch_list "''${rebased_branches[@]}")"
                printf '    pushed: %s\n' "$(join_branch_list "''${pushed_branches[@]}")"
                printf '    skipped: %s\n' "$(join_branch_list "''${skipped_push_branches[@]}")"
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

  home.file.".local/share/nix-templates/${templateName}/workspace.code-workspace" = {
    source = ./templates/direnv-shell/workspace.code-workspace;
  };

  home.file.".local/share/nix-templates/firefox/user.js" = {
    source = ./templates/user.js;
  };
}
