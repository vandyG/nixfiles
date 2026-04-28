{
  description = "vandy's personal NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Build a standalone Home Manager configuration for a named profile.
      mkHome =
        profile:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile; };
          modules = [ ./home.nix ];
        };
    in
    {
      # -----------------------------------------------------------------------
      # Standalone Home Manager configurations
      # Used on all platforms (NixOS, Ubuntu, WSL).
      # Apply with: home-manager switch --flake .#<name>
      # -----------------------------------------------------------------------
      homeConfigurations = {
        "vandy-nixos" = mkHome "nixos";
        "vandy-ubuntu" = mkHome "ubuntu";
        "vandy-wsl" = mkHome "wsl";
        "vandy-wsl_work" = mkHome "wsl_work";
      };

      # -----------------------------------------------------------------------
      # NixOS system configurations (NixOS machines only).
      # These manage kernel, hardware, networking, system services, and users.
      # Home Manager is NOT embedded here — it stays standalone above so the
      # same home.nix works on Ubuntu and WSL without changes.
      #
      # Add one entry per NixOS machine. Example for the Asus ROG Zephyrus G14
      # GA403UV (Ryzen 9 7940HS + RTX 4060 Ada Lovelace). There is no dedicated
      # nixos-hardware module for this model; compose from common modules:
      #
      #   "myhostname" = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       nixos-hardware.nixosModules.common-cpu-amd
      #       nixos-hardware.nixosModules.common-cpu-amd-pstate
      #       nixos-hardware.nixosModules.common-gpu-amd
      #       nixos-hardware.nixosModules.common-gpu-nvidia  # PRIME offload
      #       nixos-hardware.nixosModules.common-pc-laptop
      #       nixos-hardware.nixosModules.common-pc-ssd
      #       ./system/myhostname/configuration.nix
      #     ];
      #   };
      #
      # Apply with: sudo nixos-rebuild switch --flake .#myhostname
      # -----------------------------------------------------------------------
      nixosConfigurations = {
        "vandy" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self; };
          modules = [ ./system/vandy/configuration.nix ];
        };
      };
    };
}
