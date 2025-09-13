nixfiles — personal NixOS / Home Manager configuration

This repository contains the Nix configuration used to provision my user environment via Home Manager and related Nix modules.

Key notes
- Rclone setup assumes I have set up a Google Drive remote.
- Rclone config is not managed by Home Manager and must be configured separately (typically at ~/.config/rclone/rclone.conf).

Repository layout
- `home.nix` — main Home Manager configuration entrypoint used to build and apply the user profile.
- `starship.nix` — starship prompt configuration module.
- `modules/` — miscellaneous Nix modules split by purpose:
	- `git.nix` — Git-related settings and helpers.
	- `rclone.nix` — Rclone-related helpers and service definitions.
	- `shells.nix` — shell configuration (fish, bash, etc.) and environment settings.

Prerequisites
- Nix installed on the system (https://nixos.org/download.html).
- Home Manager or Nix Flakes configured if you apply `home.nix` via flakes.
- For rclone: a configured remote (e.g., Google Drive) and a local `rclone.conf` if you rely on rclone functionality.

How to use
1. Inspect `home.nix` to see enabled modules and settings.
2. Apply the configuration using your preferred method (Home Manager or flakes). Example (non-flake):

	 - Enable and run Home Manager as documented in the Home Manager manual.

3. Keep secrets and external configs (like `rclone.conf`) out of this repo.

Notes and troubleshooting
- See `TROUBLESHOOT.md` for common issues when applying this configuration.

Contact
- This is a personal configuration repository. Use the files here as a reference — adapt to your own environment and needs.
