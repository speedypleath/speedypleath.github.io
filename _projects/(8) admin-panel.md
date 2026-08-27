---
name: admin-panel
tools: [Next.js, React, TypeScript, Tailwind CSS, Supabase, Firebase, launchd, System Monitoring, Web Development]
image: /assets/img/admin-panel/services.png
description: A self-hosted macOS server dashboard for monitoring system metrics, service reachability, local/FTP files, serverless functions, bookmarks, and running maintenance actions.
---

# admin-panel

A self-hosted management dashboard built for a personal Mac mini server: monitor real-time system metrics, track service uptime and latency, browse local and remote FTP filesystems, probe serverless cloud functions, manage bookmarks, and execute operator maintenance actions.

Built with **Next.js 16 (App Router)**, **React 19**, **Tailwind CSS 4**, and **TypeScript**, running in production mode under a macOS `launchd` agent.

![Services Overview](/assets/img/admin-panel/services.png){:class="img-fluid rounded"}

## Key Features & Tabs

### 1. Services
Live reachability probe and round-trip latency tracking across all self-hosted services running on the server and tailnet.

![Services](/assets/img/admin-panel/services.png){:class="img-fluid rounded"}

### 2. System Monitoring
Real-time hardware statistics polled via `systeminformation`:
- Per-core CPU utilization and system load averages
- Memory allocation and swap usage
- Network throughput metrics
- Top active processes sorted by CPU and memory
- Mounted storage volumes and disk health

![System](/assets/img/admin-panel/system.png){:class="img-fluid rounded"}

### 3. File Browser & FTP Client
Full-featured filesystem management:
- Local filesystem browsing, directory navigation, uploads, and downloads
- Integrated remote FTP client powered by `basic-ftp`

![Files](/assets/img/admin-panel/files.png){:class="img-fluid rounded"}

### 4. Serverless Cloud Probing
Multi-cloud backend health and deployment monitoring across **Firebase Functions**, **Supabase Edge Functions**, and **Cloudflare Workers**.

![Serverless](/assets/img/admin-panel/serverless.png){:class="img-fluid rounded"}

### 5. Bookmarks Hub
Organized links grouped by category with automated metadata extraction (title, description, favicons) powered by Supabase edge functions with direct scraping fallbacks.

![Bookmarks](/assets/img/admin-panel/bookmarks.png){:class="img-fluid rounded"}

### 6. Action Runner & Maintenance
One-click administrative shell commands (gateway restarts, backups, cache invalidation) with real-time stdout/stderr streaming back to the browser.
- Protected behind HTTP Basic authentication
- Fails closed when unauthenticated to prevent unauthorized execution
- Execution timeouts and buffer capping for safe operator control

![Actions](/assets/img/admin-panel/actions.png){:class="img-fluid rounded"}

## Technical Stack

- **Framework**: Next.js 16 (App Router), React 19, TypeScript
- **Styling**: Tailwind CSS 4
- **Metrics & Hardware**: `systeminformation`
- **FTP Client**: `basic-ftp`
- **Database & State**: Supabase (PostgreSQL) with offline JSON fallback
- **Daemon / Process Manager**: macOS `launchd`

<p class="text-center">
{% include elements/button.html link="https://github.com/speedypleath/admin-panel" text="Github" size="lg" style="primary" %}
</p>
