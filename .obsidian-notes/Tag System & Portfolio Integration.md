---
tags: [teardown-cafe, obsidian, tags, portfolio, integration]
created: 2025-10-20
---

# Tag System & Portfolio Integration

Automated bidirectional linking between Teardown Cafe, Obsidian vault, and portfolio site.

## Tag Architecture

### Tag Assignment Strategy
Each teardown gets 8-12 descriptive tags:
- **Device type:** laptop-repair, 3d-printing, nas-storage
- **Skills:** thermal-management, cable-management, soldering
- **Difficulty:** beginner-friendly, advanced-repair
- **Specific tech:** opencore, zfs, bambu-lab

### Automated Matching

**Build script** (`scripts/build-obsidian-links.js`):
1. Scans Obsidian vault for tags
2. Matches with teardown frontmatter tags
3. Generates `public/data/obsidian-relationships.json`
4. Components display related notes automatically

**Manual overrides** via `src/data/obsidian-overrides.json` for edge cases.

## Portfolio Integration

### Stats API
`/api/stats.json` provides live data:
- Total teardowns
- Device types count
- Total images
- Latest entry

Portfolio pulls this dynamically for the Teardown Cafe card.

### Bidirectional Links

**Teardown → Obsidian:**
- Components show "Related in Knowledge Garden"
- Auto-matched via tags
- Clickable links to vault notes

**Obsidian → Teardown:**
- Project note links to live site
- Featured teardowns listed
- Tags connect both systems

## Key Learnings

**Automation works:** Tag matching requires zero manual maintenance after initial setup.

**Override system essential:** Not all connections are tag-based. Manual overrides handle edge cases without breaking automation.

**Build-time generation:** Pre-generating relationships faster than runtime API calls.

## Implementation Files

```
scripts/build-obsidian-links.js          # Tag scanner
src/components/TagCloud.astro            # Display tags
src/components/RelatedObsidianNotes.astro # Show matches
src/data/obsidian-overrides.json         # Manual additions
public/data/obsidian-relationships.json   # Generated
```

## Related
- [[Teardown Cafe - Deployment Guide]]
- [[Claude-Cursor Workflow]]
- [[Projects/Teardown Cafe]]
