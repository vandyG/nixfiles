{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      eval (direnv hook fish)
    '';

    # Run after other shell init code (ensure zoxide is initialized last)
    shellInitLast = ''
      # Initialize zoxide (jumping utility) for fish
      zoxide init fish | source

      abbr -a z zoxide
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
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

}
