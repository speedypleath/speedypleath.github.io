# MEMORY.md - Website Manager Memory

## Website Structure

### Project Files Format

Projects live in `_projects/` with this structure:

```markdown
---
name: project-name
tools: [Tool1, Tool2, Tool3]
image: /assets/img/filename.png
description: One-line description of the project
---

# Project Title

Full markdown content with images, videos, code blocks, etc.

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/repo" text="Github" size="lg" style="primary" %}
</p>
```

### Naming Convention

Files are numbered: `(1) OSC controller.md`, `(2) resonance.md`, etc.
- Current max number: 6
- Next project should be: `(7) project-name.md`

### Current Projects

1. OSC controller
2. resonance (Ars Electronica 2025 installation)
3. b2bAI
4. Stopor
5. auto-subtitles
6. latent-resonance (StyleGAN2 audio-visual instrument) - **Added 2026-03-24**

### Repository

- Remote: https://github.com/speedypleath/speedypleath.github.io.git
- Branch: main
- Deployment: GitHub Pages (automatic on push to main)
- Theme: portfolYOU (remote theme)

## Deployment Process

1. Changes pushed to main trigger GitHub Pages rebuild
2. Usually takes 1-2 minutes to deploy
3. Check deployment status: `gh api repos/speedypleath/speedypleath.github.io/pages/builds/latest`
4. Live site: https://speedypleath.github.io

## Learned Patterns

### Good Project Indicators

- Comprehensive README with setup instructions
- Clear description and purpose
- Active development or notable milestone
- Good documentation
- Interesting technical stack
- Visual assets (screenshots, videos, demos)

### Project Entry Best Practices

- Keep descriptions concise but informative
- Include visual media when available
- Link to GitHub repo at bottom
- Highlight technical achievements
- Mention notable usage/awards (like Ars Electronica)

## Common Issues

_None yet — will document as encountered_

## Owner Feedback

_Will record preferences and feedback here as received_

## Workflow Improvements (2026-03-24)

### Preview Build System
- Created `.github/workflows/preview-build.yml` for preview branches
- Preview branches build but don't deploy (creates downloadable artifacts)
- Master branch deploys to production via `jekyll.yml`
- Avoids GitHub Pages multi-branch deployment limitations

### Telegram Communication
- Established cross-agent messaging with main agent
- Session: `agent:main:telegram:direct:2107134288`
- Can send updates directly to user's Telegram
- Requires: `tools.sessions.visibility=all` and `tools.agentToAgent.enabled=true`

### One-at-a-Time Workflow
- Create preview branch for single project
- Get approval before merging
- Deploy to production
- Move to next project
- Better for review and iterative feedback

### Local Preview & Testing (Added 2026-03-25)
- **ALWAYS create preview branch before merging to master**
- **Use `act` for local GitHub Actions testing**: https://github.com/nektos/act
- Install: `brew install act`
- Run workflows locally: `act -j build` (or specific job name)
- Preview builds locally before pushing to avoid deployment issues
- Test UI/layout changes before going live
- Owner feedback: Should have tested locally before direct-to-master push

## TODO

- [x] Initial scan of GitHub repos to identify missing projects (completed 2026-03-24)
- [x] Create notification template for Telegram updates (completed 2026-03-24)
- [ ] Deploy pytranspleet (project #7)
- [ ] Deploy alien-invaders (project #8)
- [ ] Consider agentctl and CC2-final-project (tier 2)
- [ ] Set up periodic automated checks for new repos (weekly cron)
