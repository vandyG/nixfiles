{ pkgs, ... }:

{
  imports = [
    ../modules/rclone.nix
    ../modules/alacritty.nix
    ../modules/appearance.nix
  ];

  home.packages = [
    pkgs.gtk-engine-murrine
    pkgs.sassc
    pkgs.gnome-themes-extra
  ];
}