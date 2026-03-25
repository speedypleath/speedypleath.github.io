# Website Manager Agent - Setup Complete! 🎉

Your dedicated website management agent is now configured and ready to help maintain your portfolio at https://speedypleath.github.io

## What Was Created

### 1. Agent Configuration
- **Agent ID:** `website-manager`
- **Workspace:** `/Users/speedypleath/Projects/speedypleath.github.io/.openclaw`
- **Identity:** 🌐 Website Manager
- **Skills:** GitHub, Coding Agent
- **Model:** Claude Sonnet 4.5

### 2. Workspace Files

Created in `.openclaw/` directory:

- **AGENTS.md** - Agent's operating instructions and responsibilities
- **SOUL.md** - Agent's personality, purpose, and communication style
- **USER.md** - Information about you (Andrei)
- **MEMORY.md** - Long-term knowledge about the website structure
- **WORKFLOW.md** - Detailed workflow for project gallery updates
- **HEARTBEAT.md** - Periodic task configuration
- **scripts/** - Helper scripts for deployment checks and notifications

### 3. Directory Structure

```
speedypleath.github.io/
├── .openclaw/
│   ├── AGENTS.md
│   ├── SOUL.md
│   ├── USER.md
│   ├── MEMORY.md
│   ├── WORKFLOW.md
│   ├── HEARTBEAT.md
│   ├── SETUP.md (this file)
│   ├── memory/          # Daily logs
│   └── scripts/
│       ├── check-deployment.sh
│       └── notify-telegram.sh
├── _projects/           # Your project gallery
├── _config.yml
└── ... (rest of Jekyll site)
```

## What the Agent Does

### Primary Responsibilities

1. **Project Discovery**
   - Scans your GitHub repos weekly
   - Identifies well-documented projects worth showcasing
   - Evaluates based on README quality, tech stack, and activity

2. **Gallery Management**
   - Creates project entries in `_projects/` directory
   - Follows existing format and numbering convention
   - Ensures consistent quality and formatting

3. **Safe Deployment Workflow**
   - Works in preview branches
   - Notifies you on Telegram before deploying
   - Waits for your approval
   - Can rollback if needed

4. **Communication**
   - Sends concise updates via Telegram
   - Provides preview links
   - Easy approval workflow (just say "approve" or "rollback")

## Remaining Setup Steps

### Get Your Telegram User ID

To enable Telegram notifications, you need to find your Telegram user ID:

**Method 1: Using the helper script**
```bash
bash /tmp/get-telegram-id.sh
```
(Send a message to your bot first, then run the script)

**Method 2: Manual check**
1. Send any message to your Telegram bot
2. Run: `openclaw logs --follow`
3. Look for `from.id` in the logs

**Method 3: Alternative tool**
- DM the bot `@userinfobot` on Telegram
- It will reply with your user ID

### Update Telegram Configuration

Once you have your Telegram user ID, update the notification script:

```bash
# Replace YOUR_TELEGRAM_ID with your actual ID
sed -i '' 's/YOUR_TELEGRAM_ID/123456789/' \
  /Users/speedypleath/Projects/speedypleath.github.io/.openclaw/scripts/notify-telegram.sh
```

Or add your ID to the Telegram allowlist for the website-manager agent:
```bash
openclaw config set channels.telegram.allowFrom '["YOUR_TELEGRAM_ID"]'
```

## How to Use the Agent

### Talk to the Website Manager

You can interact with the agent in several ways:

**1. Direct message via CLI:**
```bash
openclaw agent --agent website-manager --message "Scan GitHub for new projects"
```

**2. Via Telegram (once configured):**
Just message the bot and mention tasks like:
- "Check for new projects to add to the gallery"
- "What projects are currently in the gallery?"
- "Update the website with new projects"

**3. Via scheduled tasks (cron):**
The agent can run automatic weekly scans

### Common Commands

```bash
# Check agent status
openclaw agents list

# Send a message to the agent
openclaw agent --agent website-manager --message "Your message here"

# View agent sessions
openclaw sessions list --agent website-manager

# Check agent logs
openclaw logs --agent website-manager --follow
```

## Setting Up Automatic Scans

To have the agent automatically scan for new projects weekly:

```bash
openclaw cron add --job '{
  "name": "Weekly GitHub project scan",
  "schedule": {
    "kind": "cron",
    "expr": "0 10 * * 1",
    "tz": "Europe/Bucharest"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "Scan GitHub repositories for new projects worth adding to the portfolio. Follow the workflow in WORKFLOW.md to evaluate, create entries, and notify me via Telegram for approval before deploying."
  },
  "sessionTarget": "isolated"
}'
```

This runs every Monday at 10:00 AM Bucharest time.

## Approval Workflow

When the agent finds new projects to add:

1. **Agent prepares changes** in a preview branch
2. **You receive a Telegram notification** with:
   - Summary of what's being added
   - Preview branch name
   - What makes the project notable
3. **You review** the changes (check the preview branch on GitHub)
4. **You respond:**
   - ✅ "approve" → Agent deploys to main
   - ❌ "rollback" → Agent cancels and deletes preview branch
   - 💬 Give feedback → Agent adjusts and re-notifies

## Testing the Setup

### Quick test conversation:

```bash
openclaw agent --agent website-manager --message "Hello! Please introduce yourself and tell me about your current understanding of the website structure."
```

The agent should respond with information about:
- Its purpose and responsibilities
- Current projects in the gallery (5 projects)
- The Jekyll/GitHub Pages setup
- Its workflow for updates

### Test project discovery:

```bash
openclaw agent --agent website-manager --message "List my GitHub repositories and identify which ones are not yet in the project gallery."
```

## File Locations Quick Reference

- **Agent workspace:** `/Users/speedypleath/Projects/speedypleath.github.io/.openclaw`
- **Website root:** `/Users/speedypleath/Projects/speedypleath.github.io`
- **Projects directory:** `/Users/speedypleath/Projects/speedypleath.github.io/_projects`
- **OpenClaw config:** `~/.openclaw/openclaw.json`
- **Scripts:** `/Users/speedypleath/Projects/speedypleath.github.io/.openclaw/scripts/`

## Troubleshooting

### Agent not responding
```bash
openclaw gateway status
openclaw agents list
```

### Telegram notifications not working
- Verify your Telegram user ID is in the allowlist
- Check bot token is correct
- Send a test message: `openclaw message send --channel telegram --target YOUR_ID --message "Test"`

### Git permission issues
```bash
cd /Users/speedypleath/Projects/speedypleath.github.io
git config user.name
git config user.email
gh auth status
```

### Jekyll build fails
```bash
cd /Users/speedypleath/Projects/speedypleath.github.io
bundle install
bundle exec jekyll build
```

## Next Steps

1. ✅ Get your Telegram user ID
2. ✅ Update notification script or Telegram config
3. ✅ Test the agent with a simple message
4. ✅ Let it scan your GitHub repos
5. ✅ Review its first suggested update
6. ✅ Set up automatic weekly scans (optional)

## Support

For questions or issues:
- Check OpenClaw docs: `/opt/homebrew/lib/node_modules/openclaw/docs`
- View agent logs: `openclaw logs --agent website-manager --follow`
- Ask the main agent: You can always ask me (the main agent) for help!

---

**Your website manager is ready to help keep your portfolio fresh! 🚀**
