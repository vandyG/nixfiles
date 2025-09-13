# Troubleshooting

Table of contents

- [rclone mount](#rclone-mount)

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

---
