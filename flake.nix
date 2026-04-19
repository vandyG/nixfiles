{
  description = "vandy's personal NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }:
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
      # Add one entry per NixOS machine:
      #
      #   "myhostname" = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [ ./system/myhostname/configuration.nix ];
      #   };
      #
      # Apply with: sudo nixos-rebuild switch --flake .#myhostname
      # -----------------------------------------------------------------------
      nixosConfigurations = {
        "vandy" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./system/vandy/configuration.nix ];
        };
      };
    };
}
