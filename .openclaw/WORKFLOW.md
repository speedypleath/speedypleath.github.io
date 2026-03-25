# Website Manager Workflow Guide

## Overview

This agent manages the speedypleath.github.io portfolio website, automatically discovering and showcasing projects from GitHub.

## Main Workflow: Project Gallery Update

### 1. Discovery Phase

```bash
# List all repos owned by speedypleath
gh repo list speedypleath --limit 100 --json name,description,stargazerCount,pushedAt,isArchived,isPrivate,primaryLanguage,repositoryTopics

# For each interesting repo, get detailed info
gh repo view speedypleath/REPO_NAME --json name,description,readme,url,languages,topics,stargazerCount,watchers
```

**Criteria for inclusion:**
- Not private or archived
- Has a good README (check length and structure)
- Has clear description
- Has interesting tech stack
- Not already in `_projects/` directory

### 2. Evaluation Phase

For each candidate project:

1. Read the README
2. Check if it has screenshots/media
3. Assess technical interest
4. Compare against existing projects
5. Decide if it deserves a spot

### 3. Content Creation Phase

Create a new project file following this template:

```markdown
---
name: project-slug
tools: [Tool1, Tool2, Tool3]
image: /assets/img/project-image.png
description: One-sentence description highlighting the key value
---

# Project Name

Brief introduction paragraph.

## Key Section 1

Content with details...

## Key Section 2

More content...

![Screenshot](/assets/img/screenshot.png)

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/repo-name" text="Github" size="lg" style="primary" %}
</p>
```

**Naming convention:**
- Next number: Check highest number in `_projects/`, add 1
- Format: `(N) project-name.md`

### 4. Preview Phase

```bash
# Create a preview branch
cd /Users/speedypleath/Projects/speedypleath.github.io
git checkout -b preview/gallery-update-$(date +%Y%m%d)

# Add new project file(s)
git add _projects/
git commit -m "feat: add PROJECT_NAME to gallery

- Added (N) project-name.md
- Highlights: KEY_FEATURES"

# Push to GitHub
git push origin preview/gallery-update-$(date +%Y%m%d)
```

### 5. Notification Phase

Send structured notification to Andrei via Telegram:

```
🌐 Website Gallery Update Ready

✨ New Project: PROJECT_NAME

📝 Summary:
- What: Brief description
- Tech: Main technologies used
- Why notable: Key achievement or feature

🔗 Preview branch: preview/gallery-update-YYYYMMDD
📍 Preview file: _projects/(N) project-name.md

Please review and reply:
✅ "approve" to deploy
❌ "rollback" to cancel
💬 or provide feedback
```

### 6. Approval Handling

**On approval:**
```bash
git checkout main
git pull
git merge preview/gallery-update-YYYYMMDD
git push origin main

# Check deployment
./scripts/check-deployment.sh

# Clean up
git branch -d preview/gallery-update-YYYYMMDD
git push origin --delete preview/gallery-update-YYYYMMDD

# Notify completion
```

**On rejection/rollback:**
```bash
git checkout main
git branch -D preview/gallery-update-YYYYMMDD
git push origin --delete preview/gallery-update-YYYYMMDD

# Notify cancellation
```

## Periodic Tasks

### Weekly GitHub Scan (via Heartbeat)

Every Monday, run discovery phase to check for:
- New repositories
- Recently updated repos with improved documentation
- Archived repos (potentially remove from gallery)

### Maintenance Checks

- Verify all GitHub links still work
- Check if any projects have been archived (consider removing)
- Look for projects that got significant updates (worth re-highlighting)

## Git Safety Rules

1. **Always work in branches** for changes requiring approval
2. **Never force push** to main
3. **Always pull before merging** to avoid conflicts
4. **Keep commits atomic** - one logical change per commit
5. **Write clear commit messages** following conventional commits:
   - `feat:` for new projects
   - `fix:` for corrections
   - `docs:` for content updates
   - `chore:` for maintenance

## Error Recovery

### If deployment fails:
```bash
# Check build logs
gh api repos/speedypleath/speedypleath.github.io/pages/builds/latest

# If needed, revert
git revert HEAD
git push origin main
```

### If merge conflicts:
```bash
git checkout main
git pull
git checkout preview/branch-name
git rebase main
# resolve conflicts
git rebase --continue
git push origin preview/branch-name --force-with-lease
```

## Helpful Commands

```bash
# Test Jekyll build locally
cd /Users/speedypleath/Projects/speedypleath.github.io
bundle exec jekyll serve --livereload
# Visit: http://localhost:4000

# Check git status
git status
git log --oneline -n 5

# List branches
git branch -a

# View diff before committing
git diff _projects/
```

## Telegram Communication Templates

### New project notification:
```
🌐 Gallery Update Available

✨ Added: [Project Name]
🔧 Stack: [Technologies]
⭐️ Highlights: [Key points]

🔗 Branch: preview/gallery-update-YYYYMMDD

Reply 'approve' to deploy or 'rollback' to cancel
```

### Deployment success:
```
✅ Website Updated

Deployed: [Project Name]
🌐 Live at: https://speedypleath.github.io

Changes are now visible on your portfolio
```

### Error notification:
```
⚠️ Deployment Issue

Problem: [Error description]
Branch: [branch-name]
Action needed: [What you need from Andrei]
```

## Notes

- The website uses the portfolYOU Jekyll theme
- Deployment is automatic via GitHub Pages when pushing to main
- Build usually takes 1-2 minutes
- Local preview requires Ruby and Jekyll (`bundle exec jekyll serve`)
- Images should be optimized before adding (<500KB ideally)
