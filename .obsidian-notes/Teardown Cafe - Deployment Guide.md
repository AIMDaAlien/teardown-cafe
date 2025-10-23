---
tags: [teardown-cafe, deployment, vercel, workflow]
created: 2025-10-20
---

# Teardown Cafe - Deployment Guide

## Vercel Deployment

**Live site:** teardown-cafe.vercel.app

### First-Time Setup
1. Push all commits to GitHub: `git push origin main`
2. Import project at vercel.com
3. Vercel auto-detects Astro
4. Click Deploy

### Auto-Deploy Workflow
- Every `git push` → automatic rebuild
- Deploy time: 30-60 seconds
- Preview URLs for branches

### Critical Lesson: Always Push First
**Problem:** Vercel reads from GitHub, not local files.  
**Solution:** Check for unpushed commits before expecting deployment changes.

```bash
# Check unpushed commits
git log origin/main..HEAD --oneline

# Push everything
git push origin main
```

## Local Development

```bash
npm run dev          # localhost:4321
npm run build        # test production build
npm run preview      # preview production locally
```

## Obsidian Integration

Build script (`scripts/build-obsidian-links.js`) runs locally and generates `public/data/obsidian-relationships.json`. This file must be committed - Vercel can't access local Obsidian vault.

```bash
npm run build                    # Generates Obsidian links
git add public/data/
git commit -m "Update Obsidian relationships"
git push
```

## Vercel MCP Setup

For automated deployments via Claude:

1. **Get Token:** vercel.com → Settings → Tokens → Create
2. **Add to Claude:** Settings → Integrations → MCP → Vercel
3. **Paste token** (starts with `vercel_...`)

Enables Claude to trigger deployments, check status, manage preview URLs.

## Related
- [[Teardown Cafe - Technical Setup]]
- [[Projects/Teardown Cafe]]
- [[Claude-Cursor Workflow]]
