---
title: "Sync Obsidian to iCloud on macOS, Automatically"
date: 2026-06-01
tags:
  - obsidian
  - macos
  - productivity
  - tools
description: "Setup automatic sync on iCloud for an obsidian vault using rsync and launchd"
---

I wanted my Obsidian vault available on all my Apple devices without paying for Obsidian Sync and without reaching for third-party tools. macOS already has everything needed: `rsync` for mirroring files and `launchd` for watching directories and firing jobs in the background. No polling, no cron, no daemons.

Here's the setup I landed on. It watches the vault for any file change and mirrors it to iCloud Drive within about 10 seconds.

---

## What You'll End Up With

- A shell script that runs `rsync` from your local vault to iCloud Drive
- A `launchd` agent that watches the vault directory with FSEvents and calls the script on any change
- A log at `~/Library/Logs/obsidian-sync.log` so you can see exactly when syncs happen
- Auto-start on every login — set it once, forget about it

In this guide I'm using:
- **Source:** `~/Documents/Obsidian-master`
- **Destination:** `~/Library/Mobile Documents/com~apple~CloudDocs/Obsidian`

Adjust both paths to match your setup.

---

## Step 1 — Create the Sync Script

Create `~/Scripts/sync_obsidian.sh`:

```bash
#!/bin/zsh

SOURCE="$HOME/Documents/Obsidian-master/"
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/"
LOG="$HOME/Library/Logs/obsidian-sync.log"

mkdir -p "$DEST"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Syncing Obsidian vault..." >> "$LOG"

rsync -a --delete \
  --exclude='.DS_Store' \
  --exclude='.Trash/' \
  --exclude='*.tmp' \
  "$SOURCE" "$DEST" >> "$LOG" 2>&1

if [[ $? -eq 0 ]]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sync complete." >> "$LOG"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sync failed (exit $?)." >> "$LOG"
fi
```

Make it executable:

```bash
chmod +x ~/Scripts/sync_obsidian.sh
```

A few things worth noting about the `rsync` flags:

- `-a` — archive mode: preserves timestamps, permissions, and symlinks
- `--delete` — removes files from the destination that no longer exist in the source, so the mirror stays clean
- The trailing `/` on `SOURCE` is not a typo — it tells rsync to copy the *contents* of the folder rather than the folder itself

---

## Step 2 — Create the launchd Agent

`launchd` is macOS's native service manager. Its `WatchPaths` key uses FSEvents — the same kernel-level file watcher Spotlight uses — so the script fires almost immediately when anything in your vault changes.

Create `~/Library/LaunchAgents/com.user.obsidian-sync.plist`, replacing `YOUR_USERNAME` with the output of `whoami`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.user.obsidian-sync</string>

  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>/Users/YOUR_USERNAME/Scripts/sync_obsidian.sh</string>
  </array>

  <key>WatchPaths</key>
  <array>
    <string>/Users/YOUR_USERNAME/Documents/Obsidian-master</string>
  </array>

  <key>ThrottleInterval</key>
  <integer>10</integer>

  <key>RunAtLoad</key>
  <true/>

  <key>StandardOutPath</key>
  <string>/Users/YOUR_USERNAME/Library/Logs/obsidian-sync.log</string>

  <key>StandardErrorPath</key>
  <string>/Users/YOUR_USERNAME/Library/Logs/obsidian-sync.log</string>
</dict>
</plist>
```

`ThrottleInterval` is worth understanding: if you save a note five times in three seconds, launchd will only trigger the job once, then wait 10 seconds before it can fire again. This prevents a sync storm during rapid edits.

---

## Step 3 — Grant Full Disk Access

macOS Sequoia blocks scripts from reading `~/Documents` without explicit permission.

1. Open **System Settings → Privacy & Security → Full Disk Access**
2. Click **+**, then press **Cmd+Shift+G** in the file picker
3. Add `/bin/zsh` and `/usr/bin/rsync`

---

## Step 4 — Load the Agent

```bash
launchctl load ~/Library/LaunchAgents/com.user.obsidian-sync.plist
```

This registers the agent and starts it immediately. It'll also load automatically on every login.

---

## Step 5 — Test It

Force a manual run:

```bash
launchctl kickstart -k gui/$(id -u)/com.user.obsidian-sync
```

Then tail the log:

```bash
tail -f ~/Library/Logs/obsidian-sync.log
```

You should see something like:

```
[2026-06-01 10:30:00] Syncing Obsidian vault...
[2026-06-01 10:30:01] Sync complete.
```

Make a change in Obsidian and watch it fire again within 10 seconds.

---

## Useful Commands to Keep Handy

```bash
# Check if the agent is loaded
launchctl list | grep obsidian

# Manually trigger a sync
launchctl kickstart -k gui/$(id -u)/com.user.obsidian-sync

# Stop and unload
launchctl unload ~/Library/LaunchAgents/com.user.obsidian-sync.plist

# Reload after editing the plist
launchctl unload ~/Library/LaunchAgents/com.user.obsidian-sync.plist
launchctl load ~/Library/LaunchAgents/com.user.obsidian-sync.plist
```

---

## How It All Fits Together

```
~/Documents/Obsidian-master/      ← your vault, edited in Obsidian
        |
        | FSEvents (kernel file watcher)
        ↓
  launchd agent                   ← WatchPaths detects change, waits ThrottleInterval
        |
        ↓
  sync_obsidian.sh                ← rsync -a --delete
        |
        ↓
~/Library/Mobile Documents/…/Obsidian/
        |
        ↓
  iCloud → all your devices
```

The whole thing runs at the OS level. Nothing to install, nothing to maintain, nothing that breaks when you update macOS.
