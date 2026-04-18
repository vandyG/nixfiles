{ ... }:

{
  # Fix XDG_DATA_DIRS, fontconfig, and locale on non-NixOS Linux (WSL Ubuntu).
  targets.genericLinux.enable = true;

  # programs.bash = {
  #   enable = true;
  #   initExtra = ''
  #     # If not running interactively, don't do anything
  #     if [[ $- != *i* ]]; then
  #         return
  #     fi
  #
  #     if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  #       . ~/.nix-profile/etc/profile.d/nix.sh
  #     fi
  #
  #     # If we are not already in fish, start it
  #     # The check for FISH_VERSION prevents a loop if fish ever starts a bash shell
  #     if command -v fish >/dev/null 2>&1; then
  #       exec fish -i
  #     fi
  #
  #   '';
  # };
}