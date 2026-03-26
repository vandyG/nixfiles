{ config, pkgs, lib, ... }:

let
  envProfile = builtins.getEnv "NIX_VANDY_PROFILE";
  localProfilePath = "${toString ./.}/profiles/local.nix";
  selectedProfile =
    if envProfile != "" then envProfile
    else if builtins.pathExists localProfilePath then import localProfilePath
    else throw ''
      nixfiles: set NIX_VANDY_PROFILE or create profiles/local.nix.
      Supported profiles: ubuntu, wsl, wsl_work
    '';
  profileModules = {
    ubuntu = ./profiles/ubuntu.nix;
    wsl = ./profiles/wsl.nix;
    wsl_work = ./profiles/wsl_work.nix;
  };
  profileModule = profileModules.${selectedProfile}
    or (throw "nixfiles: unsupported profile '${selectedProfile}'");
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
    NIX_VANDY_PROFILE = selectedProfile;
  };

  imports = [
    ./modules/starship.nix
    ./modules/shells.nix
    ./modules/git.nix
    ./modules/templates.nix
    profileModule
  ];
}
