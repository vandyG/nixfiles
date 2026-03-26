# nixfiles — personal NixOS / Home Manager configuration

This repository contains the Nix configuration used to provision my user environment via Home Manager and related Nix modules.

Key notes
- Rclone setup assumes I have set up a Google Drive remote.
- Rclone config is not managed by Home Manager and must be configured separately (typically at ~/.config/rclone/rclone.conf).
- A reusable `nix-vandy` helper is included; it scaffolds `.envrc` and `shell.nix` files for `direnv` projects and can also copy a Firefox `user.js` template into a profile directory.
- `nix-vandy syncbranches` automates this repo's fetch/rebase/push workflow for all local branches that track `origin/*`.
- Fish completions for `nix-vandy` are managed declaratively through Home Manager's `programs.fish.completions` and `programs.fish.functions` options, with file completions disabled by default and directory completion enabled only for `initff`.

Repository layout
- `home.nix` — main Home Manager configuration entrypoint used to build and apply the user profile.
- `modules/` — miscellaneous Nix modules split by purpose:
	- `git.nix` — Git-related settings and helpers.
	- `rclone.nix` — Rclone-related helpers and service definitions.
	- `shells.nix` — shell configuration (fish, bash, etc.) and environment settings.
	- `starship.nix` — Starship prompt configuration with a shared base config merged with a selectable theme.
	- `starship-themes/` — prompt theme definitions such as `catppuccin_mocha` and `gruvbox_dark`.
	- `templates.nix` — packages reusable project templates and exposes the `nix-vandy` helper commands.
- `modules/templates/direnv-shell/` — source templates used by `nix-vandy initshell` to create `.envrc` and `shell.nix` files.

Prerequisites
- Nix installed on the system (https://nixos.org/download.html).
- Home Manager or Nix Flakes configured if you apply `home.nix` via flakes.
- For rclone: a configured remote (e.g., Google Drive) and a local `rclone.conf` if you rely on rclone functionality.

How to use
1. Inspect `home.nix` to see enabled modules and settings.
2. Apply the configuration using your preferred method (Home Manager or flakes). Example (non-flake):

	 - Enable and run Home Manager as documented in the Home Manager manual.

3. After applying, use `nix-vandy initshell [--force]` inside any directory to drop in a ready-to-use `.envrc` and `shell.nix` that pins Python 3.13 and exports a compatible `LD_LIBRARY_PATH`.

4. Use `nix-vandy initff <firefox-profile-dir>` to copy the managed Firefox `user.js` template into a profile directory.

5. Run `nix-vandy syncbranches` from a clean checkout of this repo to fetch `origin`, fast-forward `master`, rebase every other local branch onto `master`, and push tracked `origin/*` branches with `--force-with-lease`.

6. If `~/.ssh/id_ed25519.pub` exists, the Git module automatically enables SSH-format commit signing and uses that public key as the signing key.

7. Keep secrets and external configs (like `rclone.conf`) out of this repo.

Notes and troubleshooting
- See `TROUBLESHOOT.md` for common issues when applying this configuration.

Contact
- This is a personal configuration repository. Use the files here as a reference — adapt to your own environment and needs.
