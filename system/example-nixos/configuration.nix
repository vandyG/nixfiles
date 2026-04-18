# NixOS system configuration — rename this directory to your machine's hostname.
# Register it in flake.nix nixosConfigurations:
#
#   "myhostname" = nixpkgs.lib.nixosSystem {
#     inherit system;
#     modules = [ ./system/myhostname/configuration.nix ];
#   };
#
# Generate hardware-configuration.nix on the target machine with:
#   sudo nixos-generate-config --show-hardware-config > system/myhostname/hardware-configuration.nix
# Then commit it alongside this file.

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "myhostname"; # CHANGE ME
  networking.networkmanager.enable = true;

  # ── Locale / timezone ─────────────────────────────────────────────────────
  time.timeZone = "America/New_York"; # CHANGE ME
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.vandy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    # Home Manager manages the shell config; fish must be listed in
    # programs.fish.enable so it appears in /etc/shells.
  };

  # Register fish in /etc/shells so Home Manager can set it as the login shell.
  programs.fish.enable = true;

  # ── Nix settings ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages at the system level (mirrors home.nix allowUnfree).
  nixpkgs.config.allowUnfree = true;

  # ── System packages (system-wide only, user packages are in home.nix) ─────
  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # ── Services ──────────────────────────────────────────────────────────────
  # Add machine-specific services here (e.g. services.openssh.enable = true).

  system.stateVersion = "25.05"; # Do not change after initial install.
}
