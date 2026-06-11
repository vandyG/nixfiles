{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      __nix_vandy_needs_command.body = ''
        set -l cmd (commandline -opc)
        test (count $cmd) -eq 1
      '';

      __nix_vandy_using_command = {
        argumentNames = [ "subcommand" ];
        body = ''
          set -l cmd (commandline -opc)
          test (count $cmd) -ge 2
          and test "$cmd[2]" = "$subcommand"
        '';
      };
    };

    completions = {
      nix-vandy = ''
        complete -c nix-vandy -f
        complete -c nix-vandy -s h -l help -d 'Show help'

        complete -c nix-vandy -n '__nix_vandy_needs_command' -f -a initshell -d 'Create .envrc and shell.nix in the current directory'
        complete -c nix-vandy -n '__nix_vandy_needs_command' -f -a initff -d 'Copy user.js into a Firefox profile directory'
        complete -c nix-vandy -n '__nix_vandy_needs_command' -f -a syncbranches -d 'Fetch, rebase local branches onto master, and push tracked origin branches'

        complete -c nix-vandy -n '__nix_vandy_using_command initshell' -s f -l force -d 'Overwrite existing .envrc and shell.nix files'
        complete -c nix-vandy -n '__nix_vandy_using_command initshell' -s h -l help -d 'Show help for initshell'

        complete -c nix-vandy -n '__nix_vandy_using_command initff' -s h -l help -d 'Show help for initff'
        complete -c nix-vandy -n '__nix_vandy_using_command initff' -F -a '(__fish_complete_directories (commandline -ct) "Firefox profile directory")' -d 'Firefox profile directory'

        complete -c nix-vandy -n '__nix_vandy_using_command syncbranches' -s h -l help -d 'Show help for syncbranches'
      '';
    };

    shellInit = ''
      eval (direnv hook fish)
      fish_add_path $HOME/.local/bin
    '';

    # Run after other shell init code (ensure zoxide is initialized last)
    shellInitLast = ''
      # Initialize zoxide (jumping utility) for fish
      zoxide init fish | source
      abbr -a gs 'git status'
      # PowerToys workspace launchers: prefix with `ptw-` for PowerToys Workspace
      # Standardized nomenclature: ptw-<short-name>
      # Example: `ptw-jobs` launches the Job Applications PowerToys workspace
      abbr -a ptw-jobs 'powershell.exe -Command "Invoke-Item \"C:\\Users\\vandy\\OneDrive\\Desktop\\Job Applications.lnk\""'
      abbr -a ptw-work 'powershell.exe -Command "Invoke-Item \"C:\\Users\\vandy\\OneDrive\\Desktop\\Work.lnk\""'
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # Reusable helpers available in every `.envrc`.
    stdlib = ''
      # git_identity <name> <email> [signing-key]
      #
      # Set a per-project Git identity (name/email) and SSH-sign commits & tags
      # for the duration of the direnv environment. Uses Git's GIT_CONFIG_*
      # env-var mechanism (Git >= 2.31), which takes precedence over the global
      # config from git.nix without touching any files on disk.
      #
      # The signing key defaults to ~/.ssh/id_ed25519.pub (same as the global
      # config). Pass a third argument to sign with a dedicated work key.
      #
      # Usage in a project's .envrc:
      #   git_identity "Vandy Goel" "vandy.goel@work.com" "$HOME/.ssh/work_ed25519.pub"
      git_identity() {
        local name="$1"
        local email="$2"
        local key="''${3:-$HOME/.ssh/id_ed25519.pub}"
        local i="''${GIT_CONFIG_COUNT:-0}"

        export "GIT_CONFIG_KEY_''${i}=user.name";       export "GIT_CONFIG_VALUE_''${i}=$name";  i=$((i + 1))
        export "GIT_CONFIG_KEY_''${i}=user.email";      export "GIT_CONFIG_VALUE_''${i}=$email"; i=$((i + 1))
        export "GIT_CONFIG_KEY_''${i}=gpg.format";      export "GIT_CONFIG_VALUE_''${i}=ssh";    i=$((i + 1))
        export "GIT_CONFIG_KEY_''${i}=user.signingkey"; export "GIT_CONFIG_VALUE_''${i}=$key";   i=$((i + 1))
        export "GIT_CONFIG_KEY_''${i}=commit.gpgsign";  export "GIT_CONFIG_VALUE_''${i}=true";   i=$((i + 1))
        export "GIT_CONFIG_KEY_''${i}=tag.gpgsign";     export "GIT_CONFIG_VALUE_''${i}=true";   i=$((i + 1))

        export GIT_CONFIG_COUNT="$i"

        watch_file "$key"
      }
    '';
  };

}
