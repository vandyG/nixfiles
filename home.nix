{ config, pkgs, lib, ... }:

let
  sshKey = "${builtins.getEnv "HOME"}/.ssh/id_ed25519.pub";
in

{
  home.username = "vandy";
  home.homeDirectory = "/home/vandy";
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.unzip
    pkgs.fuse3
    pkgs.zoxide
    pkgs.uv
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.gh
  ];

  home.sessionVariables = {
    EDITOR = "code";
    SHELL = "fish";
  };

  imports = [
    ./modules/starship.nix
    ./modules/shells.nix
    ./modules/rclone.nix
    ./modules/git.nix
    ./modules/templates.nix
  ];
}
