{
  config,
  pkgs,
  lib,
  # When invoked via the flake, the profile is passed as extraSpecialArgs.
  # When invoked directly (home-manager switch -f home.nix), this defaults to
  # null and the legacy NIX_VANDY_PROFILE / profiles/local.nix fallback runs.
  profile ? null,
  ...
}:

let
  envProfile = if profile != null then profile else builtins.getEnv "NIX_VANDY_PROFILE";
  localProfilePath = "${toString ./.}/profiles/local.nix";
  selectedProfile =
    if envProfile != "" then
      envProfile
    else if builtins.pathExists localProfilePath then
      import localProfilePath
    else
      throw ''
        nixfiles: set NIX_VANDY_PROFILE or create profiles/local.nix.
        Supported profiles: nixos, ubuntu, wsl, wsl_work
      '';
  profileModules = {
    nixos = ./profiles/nixos.nix;
    ubuntu = ./profiles/ubuntu.nix;
    wsl = ./profiles/wsl.nix;
    wsl_work = ./profiles/wsl_work.nix;
  };
  profileModule =
    profileModules.${selectedProfile} or (throw "nixfiles: unsupported profile '${selectedProfile}'");
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
    pkgs.nixfmt
    pkgs.nixd
    pkgs.mcp-nixos
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
