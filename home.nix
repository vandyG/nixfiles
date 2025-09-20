{ config, pkgs, lib, ... }:

let
  sshKey = "${builtins.getEnv "HOME"}/.ssh/id_ed25519.pub";
in

{
  home.username = "vandy";
  home.homeDirectory = "/home/vandy";

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.unzip
    pkgs.fuse3
    pkgs.zoxide
    pkgs.fzf
  ];

  home.file = {

  };

  home.sessionVariables = {
    EDITOR = "code";
    SHELL = "fish";
  };

  programs.home-manager.enable = true;

  imports = [
    ./starship.nix
    ./modules/shells.nix
    ./modules/rclone.nix
    ./modules/git.nix
  ];
}
