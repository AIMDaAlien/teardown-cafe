# 📸 Adding Teardowns - Complete Workflow

This guide explains the complete process for adding new teardowns with Obsidian integration.

## Quick Start

```bash
cd ~/Documents/teardown-cafe

# 1. Organize images
chmod +x organize-images.sh
./organize-images.sh

# 2. Verify teardown in dev server
npm run dev

# 3. Commit to git
git add -A
git commit -m "Add teardown: [Device Name]"

# 4. Sync to Obsidian
chmod +x sync-to-obsidian.sh
./sync-to-obsidian.sh
```

## Detailed Workflow

### Phase 1: Image Organization

**Images from this chat are named:**
- `IMG20251015184233.jpg` → Components overview
- `IMG20251015192501.jpg` → Device ports/details
- `IMG20251015192851.jpg` → Assembly step
- `IMG20251015193917.jpg` → Component installation
- `IMG20251015201625.jpg` → Assembly layers
- `IMG20251015224411.jpg` → Final build

**Process:**

1. Download images from Claude chat (right-click → Save As)
2. Save to `~/Downloads` (or update SOURCE_DIR in script)
3. Run organizer script:

```bash
cd ~/Documents/teardown-cafe
chmod +x organize-images.sh
./organize-images.sh
```

**Expected output:**
```
✓ Copied: IMG20251015184233.jpg → 01-components-overview.jpg
✓ Copied: IMG20251015192501.jpg → 02-raspberry-pi-5-ports.jpg
✓ Copied: IMG20251015192851.jpg → 03-hat-installation-with-fan.jpg
✓ Copied: IMG20251015193917.jpg → 04-case-fitting-test.jpg
✓ Copied: IMG20251015201625.jpg → 05-hat-assembly-layers.jpg
✓ Copied: IMG20251015224411.jpg → 06-final-assembly.jpg
```

### Phase 2: Verify Content

**Start dev server:**
```bash
npm run dev
```

**Navigate to:** `http://localhost:4321`

**Check:**
- ✅ New teardown card appears on homepage
- ✅ Click card → full teardown page loads
- ✅ All images display correctly
- ✅ Related notes links point to Obsidian vault

### Phase 3: Git Commit

**Commit your changes:**
```bash
git add -A
git commit -m "Add teardown: Raspberry Pi 5 NVMe Build

- Assembly documentation with 6 process images
- Performance benchmarks and optimization tips
- Linked to Homelab Pi-hole notes
- Includes thermal management analysis"

# Optional: Push to GitHub
git push origin main
```

### Phase 4: Obsidian Sync

**Update your Obsidian vault:**

```bash
chmod +x sync-to-obsidian.sh
./sync-to-obsidian.sh
```

**This script:**
1. Scans all teardown markdown files
2. Extracts metadata (title, date, device, difficulty)
3. Generates statistics (device types, difficulty breakdown)
4. Updates `Projects/Teardowns Index.md` in your Obsidian vault
5. Creates bidirectional links

**Obsidian note location:**
```
Obsidian Notes Vault/
└── Projects/
    └── Teardowns Index.md  ← Auto-generated
```

**Important:** Update `OBSIDIAN_VAULT` path in `sync-to-obsidian.sh` if your vault is elsewhere:

```bash
# Line 12-13 in sync-to-obsidian.sh
OBSIDIAN_VAULT="$HOME/Documents/Obsidian Notes Vault"  # ← Update this
OBSIDIAN_INDEX="$OBSIDIAN_VAULT/Projects/Teardowns Index.md"
```

## Automatic Workflow (Optional)

### Git Post-Commit Hook

Auto-sync to Obsidian after every commit:

```bash
cat > .git/hooks/post-commit << 'HOOK'
#!/bin/bash
echo "Syncing to Obsidian..."
./sync-to-obsidian.sh
HOOK

chmod +x .git/hooks/post-commit
```

Now every `git commit` automatically updates your Obsidian vault!

## Obsidian Integration Details

### Bidirectional Linking

**From Teardown Cafe → Obsidian:**
```markdown
relatedNotes:
  - "Homelab/Pi-hole Setup"
  - "Projects/Raspberry Pi NVMe Configuration"
```

Renders as clickable links:
```html
<a href="https://aimdaalien.github.io/knowledge-garden-vault/?note=Homelab/Pi-hole%20Setup">
  Pi-hole Setup
</a>
```

**From Obsidian → Teardown Cafe:**
```markdown
# Pi-hole Setup

Related: [Raspberry Pi 5 NVMe Build](https://teardown.cafe/teardowns/raspberry-pi-5-nvme-build)
```

### Index Structure

The auto-generated `Teardowns Index.md` contains:

```markdown
# 🔧 Teardowns Index

## Active Projects
- Individual teardown entries
- Quick summaries
- Related note links
- Direct links to full teardowns

## Teardown Statistics
- Total count
- Difficulty breakdown
- Device type categories

## Categories
- By Device Type
- By Difficulty
```

## Privacy & Metadata

**EXIF Stripping:**

Images should have metadata stripped before upload. Quick method:

```bash
# Install if needed
brew install exiftool

# Strip all EXIF data
cd ~/Documents/teardown-cafe/public/images/raspberry-pi-5-nvme
exiftool -all= *.jpg

# Remove backup files
rm *_original
```

**Automated script:**
```bash
# Add to organize-images.sh after copying
exiftool -all= "$DEST_DIR"/*.jpg
rm "$DEST_DIR"/*_original
```

## Troubleshooting

### Images not appearing

**Check paths:**
```bash
ls ~/Documents/teardown-cafe/public/images/raspberry-pi-5-nvme/
```

Should show:
```
01-components-overview.jpg
02-raspberry-pi-5-ports.jpg
03-hat-installation-with-fan.jpg
04-case-fitting-test.jpg
05-hat-assembly-layers.jpg
06-final-assembly.jpg
```

**Hard refresh browser:** `Cmd + Shift + R`

**Restart dev server:**
```bash
# Press Ctrl+C in terminal
npm run dev
```

### Obsidian sync fails

**Verify vault path:**
```bash
ls "$HOME/Documents/Obsidian Notes Vault"
```

**Update script if needed:**
```bash
nano sync-to-obsidian.sh
# Change line 13: OBSIDIAN_VAULT="/path/to/your/vault"
```

**Run manually:**
```bash
./sync-to-obsidian.sh
```

### Git push fails

**Set remote if not configured:**
```bash
# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR-USERNAME/teardown-cafe.git
git branch -M main
git push -u origin main
```

## Next Teardown

For your next teardown, the process is even simpler:

1. Upload photos to Claude
2. Provide device details
3. I create the markdown
4. You run the three scripts:
   - `./organize-images.sh`
   - `npm run dev` (verify)
   - `./sync-to-obsidian.sh`
5. Git commit

**Time estimate:** 5-10 minutes per teardown

## Scripts Summary

| Script | Purpose | When to Run |
|--------|---------|-------------|
| `organize-images.sh` | Copy & rename images | After downloading from chat |
| `sync-to-obsidian.sh` | Update Obsidian index | After git commit |
| `npm run dev` | Preview changes | Before committing |

## File Naming Convention

**Images:**
```
[number]-[descriptive-name].jpg

Examples:
01-components-overview.jpg
02-device-ports.jpg
03-internal-assembly.jpg
```

**Markdown:**
```
[device-name-with-hyphens].md

Examples:
raspberry-pi-5-nvme-build.md
dell-u2415-monitor.md
thinkpad-t480-teardown.md
```

---

**Ready for production!** 🚀

All systems configured. Next teardown should take under 10 minutes from photos to published.
