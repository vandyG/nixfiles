# Troubleshooting

Table of contents

- [rclone mount](#rclone-mount)
- [git signing](#git-signing)
- [nix-vandy helper](#nix-vandy-helper)

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

## nix-vandy helper

The `nix-vandy` helper provides `initshell`, `initff`, and `syncbranches` subcommands.

### Common errors

- `nix-vandy initshell` fails because `.envrc` or `shell.nix` already exists.
- `nix-vandy initff` fails because the Firefox profile directory does not exist.
- `nix-vandy initff` fails because `user.js` already exists in the target profile.
- `nix-vandy syncbranches` fails because the repo has staged or unstaged changes.
- `nix-vandy syncbranches` fails because `HEAD` is detached.
- `nix-vandy syncbranches` stops on a rebase conflict in one of the local branches.
- `nix-vandy syncbranches` skips push for a branch that does not track `origin/*`.

### Fixes

Overwrite shell templates intentionally:

```bash
nix-vandy initshell --force
```

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

---
