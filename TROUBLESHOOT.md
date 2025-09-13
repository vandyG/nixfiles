# Troubleshoot Rclone Mount

## 🔍 1. Check if service is running

```bash
systemctl --user status rclone-Resume.service
```

* If it says **active (running)** → mount should be there.
* If it says **failed** → there’s probably an error (wrong path, missing `user_allow_other`, etc.).

---

## 🔍 2. Look at logs

```bash
journalctl --user -u rclone-Resume.service -f
```

This shows exactly why the mount failed (bad remote name, fuse issue, etc.).

## Common Errors encountered

- Rclone remote not setup.
- mount helper error: fusermount3: option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf (see solution below)

---
## Solutions

### Enable `allow_other` globally

1. Edit FUSE config:

   ```bash
   sudo nano /etc/fuse.conf
   ```
2. Uncomment or add:

   ```
   user_allow_other
   ```
3. Save + exit, then restart WSL (`wsl --shutdown` from Windows side or just reboot).
---
