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

    programs.bash = {
    enable = true;
    initExtra = ''
      # If not running interactively, don't do anything
      if [[ $- != *i* ]]; then
          return
      fi

      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      # If we are not already in fish, start it
      # The check for FISH_VERSION prevents a loop if fish ever starts a bash shell
      if command -v fish >/dev/null 2>&1; then
        exec fish -i
      fi

    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
