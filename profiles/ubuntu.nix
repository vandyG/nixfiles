{ pkgs, ... }:

{
  imports = [
    ../modules/rclone.nix
    ../modules/alacritty.nix
    # ../modules/appearance.nix
  ];

  # Fix XDG_DATA_DIRS, fontconfig, and locale on non-NixOS Linux.
  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.sassc
    pkgs.gnome-themes-extra
  ];
}