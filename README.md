# nixfiles — personal NixOS / Home Manager configuration

This repository contains the Nix configuration used to provision my user environment via Home Manager and related Nix modules.

Key notes
- Rclone setup assumes I have set up a Google Drive remote.
- Rclone config is not managed by Home Manager and must be configured separately (typically at ~/.config/rclone/rclone.conf).
- Platform-specific behavior now lives in `profiles/` and is selected by profile name instead of long-lived Git branches.
- In WSL, `profiles/base-wsl.nix` now leaves bash as the default shell. Launch fish from the terminal app profile instead; Alacritty already does this, while VS Code integrated terminal and Windows Terminal need their default shell/profile pointed at fish.
- A reusable `nix-vandy` helper is included; it scaffolds `.envrc`, `shell.nix`, and a per-project VS Code `.code-workspace` file for `direnv` projects and can also copy a Firefox `user.js` template into a profile directory.
- `nix-vandy syncbranches` automates this repo's fetch/rebase/push workflow for all local branches that track `origin/*`.
- Fish completions for `nix-vandy` are managed declaratively through Home Manager's `programs.fish.completions` and `programs.fish.functions` options, with file completions disabled by default and directory completion enabled only for `initff`.

Firefox
- Detailed setup is in [docs/firefox.md](docs/firefox.md).
- The bundled Catppuccin Firefox theme lives in `modules/templates/firefox/catppuccin-theme/`.
- The bundled Catppuccin website userstyle lives in `modules/templates/firefox/import.json`.
- Use Firefox Color for browser theming and Stylus for website theming.

Repository layout
- `home.nix` — main Home Manager configuration entrypoint used to build and apply the user profile.
- `modules/` — miscellaneous Nix modules split by purpose:
	- `git.nix` — Git-related settings and helpers.
	- `rclone.nix` — Rclone-related helpers and service definitions.
	- `alacritty.nix` — Alacritty configuration used by the Ubuntu profile; its terminal profile launches fish directly.
	- `appearance.nix` — optional GNOME/GTK appearance helpers used by the Ubuntu profile.
	- `shells.nix` — shell configuration (fish, bash, etc.) and environment settings.
	- `starship.nix` — Starship prompt configuration with a shared base config merged with a selectable theme.
	- `starship-themes/` — prompt theme definitions such as `catppuccin_mocha` and `gruvbox_dark`.
	- `templates.nix` — packages reusable project templates and exposes the `nix-vandy` helper commands.
- `profiles/` — profile selectors that layer platform-specific modules and overrides on top of the shared configuration.
- `profiles/base-wsl.nix` — shared WSL base profile bits; the `programs.bash` stanza is currently commented out, so bash remains the default shell and any fish startup needs to come from the terminal app profile.
- `modules/templates/direnv-shell/` — source templates used by `nix-vandy initshell` to create `.envrc`, `shell.nix`, and a VS Code workspace file.
- `modules/templates/firefox/` — Firefox customization assets, including the bundled Catppuccin theme and userstyle import data.
- `docs/firefox.md` — detailed Firefox setup guide covering Firefox Color and Stylus imports.

Prerequisites
- Nix installed on the system (https://nixos.org/download.html).
- Home Manager or Nix Flakes configured if you apply `home.nix` via flakes.
- For rclone: a configured remote (e.g., Google Drive) and a local `rclone.conf` if you rely on rclone functionality.

How to use
1. Inspect `home.nix` to see enabled modules and settings.
2. Select the active platform before applying Home Manager. Either export `NIX_VANDY_PROFILE` or create an untracked `profiles/local.nix` file that returns one of `"ubuntu"`, `"wsl"`, or `"wsl_work"`.

	Example `profiles/local.nix`:

	```nix
	"wsl_work"
	```

3. Apply the configuration using your preferred method (Home Manager or flakes). Example (non-flake):

	 - Enable and run Home Manager as documented in the Home Manager manual.
	 - If you are using WSL, set VS Code integrated terminal, Windows Terminal, or Alacritty to start fish directly; this repo no longer auto-switches bash into fish for you.

4. After applying, use `nix-vandy initshell [--force]` inside any directory to drop in a ready-to-use `.envrc`, `shell.nix`, and `<dirname>.code-workspace` file. The generated workspace file applies the same Nix language server and formatter settings used in this repo.

5. For Firefox customization, use `nix-vandy initff <firefox-profile-dir>` to install the managed Firefox `user.js` template, then follow [docs/firefox.md](docs/firefox.md) for Firefox Color and Stylus setup.

6. Run `nix-vandy syncbranches` only if you still need to maintain the previous branch-based workflow during the transition.

7. If `~/.ssh/id_ed25519.pub` exists, the Git module automatically enables SSH-format commit signing and uses that public key as the signing key.

8. Keep secrets and external configs (like `rclone.conf`) out of this repo.

Notes and troubleshooting
- See `TROUBLESHOOT.md` for common issues when applying this configuration.

Contact
- This is a personal configuration repository. Use the files here as a reference — adapt to your own environment and needs.
