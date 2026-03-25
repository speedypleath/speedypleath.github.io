# Quick Start Guide

## Try the Agent Now

### 1. Get Your Telegram ID (2 minutes)

Send a message to your Telegram bot, then run:
```bash
bash /tmp/get-telegram-id.sh
```

Save the ID it gives you.

### 2. Enable Notifications

Replace `YOUR_TELEGRAM_ID` with your actual ID:
```bash
# Update the notification script
sed -i '' 's/YOUR_TELEGRAM_ID/YOUR_ACTUAL_ID/' \
  /Users/speedypleath/Projects/speedypleath.github.io/.openclaw/scripts/notify-telegram.sh

# OR add to Telegram config
openclaw config set channels.telegram.allowFrom '["YOUR_ACTUAL_ID"]'
openclaw gateway restart
```

### 3. Test the Agent

```bash
openclaw agent --agent website-manager --message "Hello! Scan my GitHub repositories and tell me which projects aren't in the gallery yet."
```

### 4. Let It Work

If it finds projects to add:
- It will create a preview branch
- Notify you on Telegram
- Wait for your "approve" or "rollback"

## That's It!

See `SETUP.md` for full details and `WORKFLOW.md` for how it works.

---

**Quick Commands:**

```bash
# Talk to the agent
openclaw agent --agent website-manager --message "YOUR MESSAGE"

# Check what it's doing
openclaw sessions list --agent website-manager

# View logs
openclaw logs --agent website-manager --follow

# Weekly auto-scan (optional)
openclaw cron add --job '{
  "name": "Weekly project scan",
  "schedule": {"kind": "cron", "expr": "0 10 * * 1"},
  "payload": {
    "kind": "agentTurn",
    "message": "Scan GitHub for new projects and notify me of updates"
  },
  "sessionTarget": "isolated"
}'
```
