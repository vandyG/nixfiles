# nixfiles — personal NixOS / Home Manager configuration

This repository contains the Nix configuration used to provision my user environment via Home Manager and related Nix modules.

Key notes
- Rclone setup assumes I have set up a Google Drive remote.
- Rclone config is not managed by Home Manager and must be configured separately (typically at ~/.config/rclone/rclone.conf).
- Platform-specific behavior now lives in `profiles/` and is selected by profile name instead of long-lived Git branches.
- Supported profiles: `nixos`, `ubuntu`, `wsl`, `wsl_work`.
- The `wsl_work` profile targets the `vgoel` Linux account; the other profiles target `vandy`.
- In WSL, `profiles/base-wsl.nix` now leaves bash as the default shell. Launch fish from the terminal app profile instead; Alacritty already does this, while VS Code integrated terminal and Windows Terminal need their default shell/profile pointed at fish.
- Windows Terminal splits shared appearance data into `modules/templates/windows-terminal/appearance.json` and keeps machine-specific profiles in `modules/templates/windows-terminal/settings.json`; its Ubuntu profile starts `fish` through WSL so the terminal opens in the right shell.
- GitHub HTTPS remotes are rewritten to SSH by default (`https://github.com/...` becomes `git@github.com:...`) so `git push` does not prompt for a username/password.
- A reusable `nix-vandy` helper is included; it scaffolds `.envrc`, `shell.nix`, and a per-project VS Code `.code-workspace` file for `direnv` projects and can also copy a Firefox `user.js` template into a profile directory.
- `nix-vandy syncbranches` automates this repo's fetch/rebase/push workflow for all local branches that track `origin/*`.
- Per-project Git identity is set with the direnv `git_identity "<name>" "<email>" [signing-key]` helper (defined in `modules/shells.nix`). Call it from a project's `.envrc`; it overrides `user.name`/`user.email` and SSH-signs commits and tags via Git's `GIT_CONFIG_*` env vars, leaving the global identity in `git.nix` as the default. `gh` (GitHub CLI) auth is unaffected and stays on the personal account.
- Fish completions for `nix-vandy` are managed declaratively through Home Manager's `programs.fish.completions` and `programs.fish.functions` options, with file completions disabled by default and directory completion enabled only for `initff`.
- `wscode <drive-letter> [path]` opens a directory in VS Code via Windows PowerShell (`powershell.exe -Command "code <drive>:\<path>"`). Useful in WSL when a distro root is mapped to a Windows drive letter (e.g. `Z:`). Defaults to the current directory if no path is given. Tab-completes drive letters and directory paths.
- `targets.genericLinux.enable` is set to `true` in the `ubuntu` and `wsl`/`wsl_work` profiles. It is intentionally absent from the `nixos` profile — NixOS handles `XDG_DATA_DIRS`, fontconfig, and locale natively and enabling it there would conflict.

Firefox
- Detailed setup is in [docs/firefox.md](docs/firefox.md).
- The bundled Catppuccin Firefox theme lives in `modules/templates/firefox/catppuccin-theme/`.
- The bundled Catppuccin website userstyle lives in `modules/templates/firefox/import.json`.
- Use Firefox Color for browser theming and Stylus for website theming.

Repository layout
- `flake.nix` — Nix flake entrypoint; exposes `homeConfigurations` (all platforms) and `nixosConfigurations` (NixOS machines). `flake.lock` pins nixpkgs.
- `home.nix` — Home Manager configuration entrypoint. Works both via the flake (`home-manager switch --flake .#<name>`) and directly (`home-manager switch -f home.nix`).
- `system/` — NixOS system configurations, one subdirectory per machine. Each contains a `configuration.nix` (and a machine-generated `hardware-configuration.nix`). Applied with `sudo nixos-rebuild switch --flake .#<hostname>`. Home Manager is NOT embedded here; it stays standalone so `home.nix` remains portable.
- `system/example-nixos/` — starter template; copy and rename the directory to your machine's hostname to add a new NixOS host.
- `modules/` — miscellaneous Nix modules split by purpose:
	- `git.nix` — Git-related settings and helpers.
	- `rclone.nix` — Rclone-related helpers and service definitions.
	- `alacritty.nix` — Alacritty configuration used by the Ubuntu profile; its terminal profile launches fish directly.
	- `appearance.nix` — optional GNOME/GTK appearance helpers used by the Ubuntu profile.
	- `shells.nix` — shell configuration (fish, bash, etc.), environment settings, and the direnv `stdlib` `git_identity` helper for per-project Git identity and SSH signing.
	- `starship.nix` — Starship prompt configuration with a shared base config merged with a selectable theme. To switch Catppuccin flavour, set `catppuccinFlavour` to one of `mocha`, `frappe`, `macchiato`, or `latte`. To switch to a different theme entirely, change `theme = themes.catppuccin` to `theme = themes.gruvbox_dark`.
	- `starship-themes/` — prompt theme definitions: `catppuccin.nix` (all four Catppuccin flavours, parameterised by flavour name) and `gruvbox_dark.nix`.
	- `templates.nix` — packages reusable project templates and exposes the `nix-vandy` helper commands.
	- `copilot/copilot.nix` — GitHub Copilot CLI configuration. Skills and agents are consumed from `copilotSources` (injected via `extraSpecialArgs`) and managed by the Home Manager `programs.github-copilot-cli.skills` / `.agents` options.
	- `copilot/sources.nix` — single source of truth for all Copilot skills and agents. Maps skill/agent names to paths: local skills reference `./skills/<name>` (a directory containing `SKILL.md`); external skills reference store paths from flake inputs. Add a new external repo by: (1) declaring the input in `flake.nix` with `flake = false`, (2) destructuring it in `outputs` and passing it to `import ./modules/copilot/sources.nix { ... }`, (3) adding entries in `sources.nix`.
	- `copilot/skills/` — locally owned skills (`powerbi-modeling`, `powerbi-sql`). Each is a directory containing a `SKILL.md` and optional supporting files. External skills (e.g. `kepano/obsidian-skills`) are pinned as flake inputs and referenced in `sources.nix` — do not copy them here.
- `profiles/` — profile selectors that layer platform-specific modules and overrides on top of the shared configuration.
- `profiles/base-wsl.nix` — shared WSL base profile bits; the `programs.bash` stanza is currently commented out, so bash remains the default shell and any fish startup needs to come from the terminal app profile.
- `profiles/nixos.nix` — NixOS profile; imports rclone, alacritty, and appearance modules but does NOT set `targets.genericLinux.enable` (NixOS handles this natively).
- `modules/templates/direnv-shell/` — source templates used by `nix-vandy initshell` to create `.envrc`, `shell.nix`, and a VS Code workspace file.
- `modules/templates/firefox/` — Firefox customization assets, including the bundled Catppuccin theme and userstyle import data.
- `modules/templates/windows-terminal/` — Windows Terminal configuration assets, including a shared appearance fragment and a machine-specific settings template with a WSL profile that launches fish directly.
- `docs/firefox.md` — detailed Firefox setup guide covering Firefox Color and Stylus imports.

Prerequisites
- Nix installed on the system (https://nixos.org/download.html).
- Flakes and the `nix-command` experimental feature enabled (`nix.settings.experimental-features = ["nix-command" "flakes"]`).
- For rclone: a configured remote (e.g., Google Drive) and a local `rclone.conf` if you rely on rclone functionality.

How to use
1. Inspect `home.nix` to see enabled modules and settings.
2. Select the active platform before applying Home Manager. Either export `NIX_VANDY_PROFILE` or create an untracked `profiles/local.nix` file that returns one of `"nixos"`, `"ubuntu"`, `"wsl"`, or `"wsl_work"`.

	Use `wsl_work` when applying the config from the `vgoel` account.

	Example `profiles/local.nix`:

	```nix
	"wsl_work"
	```

3. Apply the configuration.

	**Flake workflow (recommended):**

	```bash
	# Ubuntu / WSL
	home-manager switch --flake .#vandy-wsl

	# NixOS — user environment
	home-manager switch --flake .#vandy-nixos

	# NixOS — system config (run once per system change)
	sudo nixos-rebuild switch --flake .#<hostname>
	```

	**Direct / non-flake workflow (still supported):**

	```bash
	NIX_VANDY_PROFILE=wsl home-manager switch -f ~/nixfiles/home.nix
	```

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
