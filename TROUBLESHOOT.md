# Troubleshooting

Table of contents

- [rclone mount](#rclone-mount)
- [git signing](#git-signing)
- [firefox customizations](#firefox-customizations)
- [nix-vandy helper](#nix-vandy-helper)
- [profile selection](#profile-selection)
- [wsl shell startup](#wsl-shell-startup)

## rclone mount

Short guide to diagnose and fix a failing rclone mount service (user unit: `rclone-Resume.service`).

### 1. Check if the service is running

```bash
systemctl --user status rclone-Resume.service
```

- If it says **active (running)** → the mount should be present.
- If it says **failed** → there’s probably an error (wrong path, missing `user_allow_other`, bad remote name, etc.).

---

### 2. Inspect the logs

```bash
journalctl --user -u rclone-Resume.service -f
```

This will show why the mount failed (bad remote name, FUSE error, permission issues, etc.).

### Common errors

- Rclone remote not configured.
- fusermount3 error: "option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf".
- Local mount path `%h/data/Resume` does not exist yet.

---

### Solutions

#### Enable `allow_other` globally

1. Edit the FUSE config as root:

```bash
sudo nano /etc/fuse.conf
```

2. Uncomment or add the following line:

```text
user_allow_other
```

3. Save and exit. Then reboot or restart WSL (if applicable):

```bash
#windows: wsl --shutdown (from Windows side)
# otherwise, reboot the system
```

#### Create the local mount directory

The service mounts into `%h/data/Resume`. If that directory does not exist, create it first:

```bash
mkdir -p ~/data/Resume
```

#### Verify the configured remote name

The service expects the remote path `vandy23:Resume/`. Confirm it exists:

```bash
rclone listremotes
rclone lsd vandy23:
```

## git signing

The Git module enables SSH-format commit signing only when `~/.ssh/id_ed25519.pub` exists.

### Symptoms

- Commits are not signed even though Home Manager has been applied.
- Git errors that the SSH signing key cannot be found.

### Fix

Create the expected SSH key pair or adjust the module to point at the public key you actually use:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

After the key exists, re-apply Home Manager so Git picks up the signing settings.

## firefox customizations

The full setup guide is in [docs/firefox.md](docs/firefox.md). This section covers the common failure modes.

### Symptoms

- The bundled Catppuccin Firefox theme does not appear after import.
- The bundled Catppuccin website styling does not apply on supported sites.
- Firefox shows the wrong profile, so the imported theme or userstyle seems to be missing.

### Fixes

Install the Firefox Color extension and import the Catppuccin theme from [modules/templates/firefox/catppuccin-theme/](modules/templates/firefox/catppuccin-theme/). The packaging and import flow are described in the Catppuccin Firefox guide.

Install the Stylus extension and import the Catppuccin userstyle from [modules/templates/firefox/import.json](modules/templates/firefox/import.json). The import flow is described in the Stylus usage guide.

If the customizations are not visible, confirm that you imported them into the Firefox profile you actually use and that the relevant extensions are enabled for that profile.

## nix-vandy helper

The `nix-vandy` helper provides `initshell`, `initff`, and `syncbranches` subcommands.

### Common errors

- `nix-vandy initshell` fails because `.envrc` or `shell.nix` already exists.
- `nix-vandy initshell` fails because the generated `<dirname>.code-workspace` file already exists.
- `nix-vandy initff` fails because the Firefox profile directory does not exist.
- `nix-vandy initff` fails because `user.js` already exists in the target profile.
- `nix-vandy syncbranches` fails because the repo has staged or unstaged changes.
- `nix-vandy syncbranches` fails because `HEAD` is detached.
- `nix-vandy syncbranches` stops on a rebase conflict in one of the local branches.
- `nix-vandy syncbranches` skips push for a branch that does not track `origin/*`.
- Fish does not offer completions for `nix-vandy` after the config was updated.

### Fixes

Overwrite shell templates intentionally:

```bash
nix-vandy initshell --force
```

The same `--force` flag also replaces the generated VS Code workspace file when it already exists.

Check Firefox profile directories before copying the template:

```bash
ls ~/.mozilla/firefox
nix-vandy initff ~/.mozilla/firefox/<profile>
```

Before running the branch sync workflow, ensure the checkout is clean:

```bash
git status --short --branch
nix-vandy syncbranches
```

If the workflow stops during a rebase conflict, resolve the conflict in the current branch and continue or abort manually:

```bash
git status
git rebase --continue
# or
git rebase --abort
```

If Fish is not showing completions for `nix-vandy`, re-apply Home Manager and start a new shell session so Fish reloads the generated completion definitions.

The custom Fish helper functions for `nix-vandy` intentionally avoid the `__fish_*` prefix so they do not collide with Fish's internal helper namespace.

## profile selection

The repo now selects platform-specific configuration through a profile instead of permanent Git branches.

### Common errors

- Home Manager evaluation fails because neither `NIX_VANDY_PROFILE` nor `profiles/local.nix` is set.
- Home Manager evaluation fails because the selected profile is not one of `ubuntu`, `wsl`, or `wsl_work`.

### Fixes

Set the profile for one invocation:

```bash
NIX_VANDY_PROFILE=wsl_work home-manager switch -f ~/nixfiles/home.nix
```

Or create an untracked `profiles/local.nix` file in the repo so each machine keeps its own default profile:

```nix
"wsl_work"
```

The pre-migration branch state is recoverable from these local backup tags:

- `backup/pre-profile-migration-master`
- `backup/pre-profile-migration-ubuntu`
- `backup/pre-profile-migration-wsl`
- `backup/pre-profile-migration-wsl_work`

## wsl shell startup

In `profiles/base-wsl.nix`, the `programs.bash` block may be commented out. That leaves bash as the default shell in WSL, so fish will only start if the terminal app profile is configured to launch it directly.

### Symptoms

- WSL starts in bash instead of fish.
- VS Code integrated terminal, Windows Terminal, or Alacritty open bash because their profile/default shell still points at bash.
- Bash sessions no longer source `~/.nix-profile/etc/profile.d/nix.sh` from that Home Manager hook.

### Fixes

Set the terminal app to launch fish directly if you want fish on startup. Alacritty already does this through `modules/alacritty.toml`; VS Code integrated terminal and Windows Terminal need their default profile or shell command updated separately.

If you want the old behavior back inside WSL itself, uncomment the `programs.bash` stanza in `profiles/base-wsl.nix` and re-apply Home Manager so bash can hand off to fish again.

If you prefer keeping it disabled, leave bash as the WSL default and rely on the terminal app profile to start fish.

---
