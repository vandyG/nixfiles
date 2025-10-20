{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
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
    enableFishIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

}
