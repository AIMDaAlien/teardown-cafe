# Portfolio-Obsidian-Teardown Integration Spec

## Overview
Automate bidirectional linking between:
- Portfolio (aimdaalien.github.io)
- Obsidian Knowledge Garden
- Teardown Cafe

With automated tag matching and manual override capability.

## Phase 1: Add Tags to Teardowns

### 1.1 Update Frontmatter Schema
File: `src/content.config.ts`

```typescript
const teardownSchema = z.object({
  title: z.string(),
  description: z.string(),
  pubDate: z.date(),
  device: z.enum(['laptop', 'smartphone', 'raspberry-pi', 'nas', '3d-printer']),
  difficulty: z.enum(['easy', 'medium', 'hard']),
  heroImage: z.string(),
  video: z.string().optional(),
  relatedNotes: z.array(z.string()).optional(),
  tags: z.array(z.string()).optional(), // ADD THIS
});
```

### 1.2 Tag Assignments for Existing Teardowns

**bambu-lab-a1-mini-setup.md:**
```yaml
tags: [3d-printing, beginner-friendly, workspace-organization, bambu-lab, automation]
```

**raspberry-pi-5-nvme-build.md:**
```yaml
tags: [raspberry-pi, sbc, nvme-storage, homelab, linux, pi-hole]
```

**truenas-enterprise-sas-build.md:**
```yaml
tags: [nas-storage, truenas, sas-drives, 3d-printing, thermal-management, zfs]
```

**hp-elitebook-g7-840-may-2023.md:**
```yaml
tags: [laptop-repair, hp-elitebook, frankenstein-build, repurposing, hardware-mod]
```

**macbook-air-2015-13inch-under-the-hood.md:**
```yaml
tags: [macbook, laptop-repair, nvme-upgrade, apple-hardware, firmware]
```

**moto-g-stylus-2022-screen-repair.md:**
```yaml
tags: [smartphone-repair, screen-replacement, motorola, battery-removal]
```

**thinkpad-t490s-2023.md:**
```yaml
tags: [thinkpad, laptop-repair, lenovo, ultrabook]
```

## Phase 2: Build Automated Tag Sync

### 2.1 Create Obsidian Relationship Builder
File: `scripts/build-obsidian-links.js`

```javascript
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import { glob } from 'glob';

const OBSIDIAN_VAULT = process.env.HOME + '/Documents/Obsidian Notes Vault';
const TEARDOWN_DIR = './src/data/teardowns';
const OUTPUT_FILE = './public/data/obsidian-relationships.json';
const OVERRIDES_FILE = './src/data/obsidian-overrides.json';

async function scanObsidianNotes() {
  const notes = new Map();
  const files = await glob(`${OBSIDIAN_VAULT}/**/*.md`);
  
  for (const file of files) {
    const content = fs.readFileSync(file, 'utf-8');
    const { data } = matter(content);
    
    if (!data.tags) continue;
    
    const relativePath = path.relative(OBSIDIAN_VAULT, file).replace('.md', '');
    const tags = Array.isArray(data.tags) ? data.tags : [data.tags];
    
    tags.forEach(tag => {
      const normalizedTag = tag.replace('#', '').toLowerCase();
      if (!notes.has(normalizedTag)) notes.set(normalizedTag, []);
      notes.get(normalizedTag).push({
        title: data.title || path.basename(file, '.md'),
        path: relativePath
      });
    });
  }
  
  return notes;
}

async function scanTeardowns() {
  const teardowns = new Map();
  const files = await glob(`${TEARDOWN_DIR}/*.md`);
  
  for (const file of files) {
    const content = fs.readFileSync(file, 'utf-8');
    const { data } = matter(content);
    
    if (!data.tags) continue;
    
    const slug = path.basename(file, '.md');
    
    data.tags.forEach(tag => {
      const normalizedTag = tag.toLowerCase();
      if (!teardowns.has(normalizedTag)) teardowns.set(normalizedTag, []);
      teardowns.get(normalizedTag).push({
        title: data.title,
        slug: slug
      });
    });
  }
  
  return teardowns;
}

async function buildRelationships() {
  const obsidianByTag = await scanObsidianNotes();
  const teardownsByTag = await scanTeardowns();
  
  // Load overrides
  let overrides = {};
  if (fs.existsSync(OVERRIDES_FILE)) {
    overrides = JSON.parse(fs.readFileSync(OVERRIDES_FILE, 'utf-8'));
  }
  
  const relationships = {};
  const tagStats = { total: 0, matched: 0, tags: {} };
  
  // Match tags
  for (const [tag, notes] of obsidianByTag) {
    tagStats.total++;
    if (teardownsByTag.has(tag)) {
      tagStats.matched++;
      relationships[tag] = {
        obsidianNotes: notes.map(n => ({
          title: n.title,
          path: n.path,
          url: `https://aimdaalien.github.io/knowledge-garden-vault/?note=${encodeURIComponent(n.path)}`
        })),
        teardowns: teardownsByTag.get(tag).map(t => ({
          title: t.title,
          slug: t.slug,
          url: `/teardowns/${t.slug}`
        }))
      };
      
      tagStats.tags[tag] = {
        obsidian: notes.length,
        teardowns: teardownsByTag.get(tag).length
      };
    }
  }
  
  // Apply overrides
  for (const [slug, override] of Object.entries(overrides)) {
    if (override.additionalNotes) {
      // Add manual connections
      for (const notePath of override.additionalNotes) {
        const tag = `manual-${slug}`;
        if (!relationships[tag]) relationships[tag] = { obsidianNotes: [], teardowns: [] };
        relationships[tag].obsidianNotes.push({
          title: path.basename(notePath),
          path: notePath,
          url: `https://aimdaalien.github.io/knowledge-garden-vault/?note=${encodeURIComponent(notePath)}`
        });
      }
    }
  }
  
  // Ensure output directory exists
  const outputDir = path.dirname(OUTPUT_FILE);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }
  
  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(relationships, null, 2));
  fs.writeFileSync(
    './public/data/tag-stats.json',
    JSON.stringify(tagStats, null, 2)
  );
  
  console.log(`✓ Generated ${OUTPUT_FILE}`);
  console.log(`✓ Matched ${tagStats.matched}/${tagStats.total} tags`);
}

buildRelationships().catch(console.error);
```

### 2.2 Add to Build Process
File: `package.json`

```json
{
  "scripts": {
    "prebuild": "node scripts/build-obsidian-links.js",
    "predev": "node scripts/build-obsidian-links.js",
    "build": "astro build",
    "dev": "astro dev"
  },
  "dependencies": {
    "glob": "^10.3.10",
    "gray-matter": "^4.0.3"
  }
}
```

## Phase 3: Create UI Components

### 3.1 Tag Cloud Component
File: `src/components/TagCloud.astro`

```astro
---
interface Props {
  tags: string[];
}

const { tags } = Astro.props;
---

<div class="tag-cloud">
  {tags.map(tag => (
    <a href={`/tags/${tag}`} class="tag-pill">
      #{tag}
    </a>
  ))}
</div>

<style>
  .tag-cloud {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin: 1rem 0;
  }
  
  .tag-pill {
    padding: 0.25rem 0.75rem;
    background: var(--surface-container);
    border-radius: 9999px;
    font-size: 0.875rem;
    text-decoration: none;
    color: var(--on-surface);
    transition: all 0.2s;
  }
  
  .tag-pill:hover {
    background: var(--surface-container-high);
    transform: translateY(-1px);
  }
</style>
```

### 3.2 Related Obsidian Notes Component
File: `src/components/RelatedObsidianNotes.astro`

```astro
---
interface Props {
  tags: string[];
  slug: string;
}

const { tags, slug } = Astro.props;

// Load relationships
let relationships = {};
try {
  const data = await fetch('/data/obsidian-relationships.json');
  relationships = await data.json();
} catch (e) {
  // File doesn't exist yet - build will create it
  relationships = {};
}

// Find all related notes for these tags
const relatedNotes = new Map();

tags.forEach(tag => {
  if (relationships[tag]?.obsidianNotes) {
    relationships[tag].obsidianNotes.forEach(note => {
      relatedNotes.set(note.path, note);
    });
  }
});

// Check for manual additions
const manualTag = `manual-${slug}`;
if (relationships[manualTag]?.obsidianNotes) {
  relationships[manualTag].obsidianNotes.forEach(note => {
    relatedNotes.set(note.path, note);
  });
}

const notes = Array.from(relatedNotes.values());
---

{notes.length > 0 && (
  <section class="related-obsidian">
    <h3>📝 Related in Knowledge Garden</h3>
    <ul>
      {notes.map(note => (
        <li>
          <a href={note.url} target="_blank" rel="noopener">
            {note.title}
            <svg class="external-link" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6M15 3h6v6M10 14L21 3"/>
            </svg>
          </a>
        </li>
      ))}
    </ul>
  </section>
)}

<style>
  .related-obsidian {
    margin: 2rem 0;
    padding: 1.5rem;
    background: var(--surface-container-low);
    border-radius: 12px;
  }
  
  .related-obsidian h3 {
    margin-bottom: 1rem;
    color: var(--on-surface);
  }
  
  .related-obsidian ul {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }
  
  .related-obsidian a {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: var(--primary);
    text-decoration: none;
    transition: color 0.2s;
  }
  
  .related-obsidian a:hover {
    color: var(--primary-container);
  }
  
  .external-link {
    width: 14px;
    height: 14px;
    opacity: 0.6;
  }
</style>
```

### 3.3 Update Teardown Layout
File: `src/layouts/TeardownLayout.astro` (or wherever teardown content is rendered)

```astro
---
// Existing imports
import TagCloud from '../components/TagCloud.astro';
import RelatedObsidianNotes from '../components/RelatedObsidianNotes.astro';

const { frontmatter } = Astro.props;
const { tags, relatedNotes } = frontmatter;
---

<article>
  <!-- Existing content -->
  
  <!-- After main content, before footer -->
  {tags && tags.length > 0 && (
    <>
      <TagCloud tags={tags} />
      <RelatedObsidianNotes tags={tags} slug={Astro.url.pathname.split('/').pop()} />
    </>
  )}
  
  <!-- Existing manual relatedNotes -->
  {relatedNotes && <RelatedNotes notes={relatedNotes} />}
</article>
```

## Phase 4: Portfolio Integration

### 4.1 Create Stats API Endpoint
File: `src/pages/api/stats.json.ts`

```typescript
import { getCollection } from 'astro:content';

export async function GET() {
  const teardowns = await getCollection('teardowns');
  
  const deviceTypes = new Set(teardowns.map(t => t.data.device));
  const totalImages = teardowns.reduce((sum, t) => {
    // Rough estimate: count image references in markdown
    return sum + (t.body.match(/!\[.*?\]\(.*?\)/g) || []).length;
  }, 0);
  
  const latest = teardowns.sort((a, b) => 
    b.data.pubDate.getTime() - a.data.pubDate.getTime()
  )[0];
  
  return new Response(JSON.stringify({
    totalTeardowns: teardowns.length,
    totalImages: totalImages,
    deviceTypes: deviceTypes.size,
    latestEntry: {
      title: latest.data.title,
      date: latest.data.pubDate.toISOString().split('T')[0],
      slug: latest.slug
    }
  }, null, 2), {
    headers: { 'Content-Type': 'application/json' }
  });
}
```

### 4.2 Portfolio Card Spec
Location: `aimdaalien.github.io` projects section

```html
<div class="project-card featured">
  <div class="project-hero">
    <img src="assets/teardown-cafe-hero.jpg" alt="Teardown Cafe - Hardware teardowns and repairs">
  </div>
  
  <div class="project-content">
    <h3>🔧 Teardown Cafe</h3>
    <p>Technical hardware teardowns with detailed photography, repair guides, and component analysis</p>
    
    <div class="project-stats" id="teardown-stats">
      <span data-stat="teardowns">Loading...</span>
      <span data-stat="devices">Loading...</span>
      <span data-stat="photos">Loading...</span>
    </div>
    
    <div class="project-tech">
      <span class="tech-badge">Astro v5</span>
      <span class="tech-badge">Material You 3</span>
      <span class="tech-badge">Markdown</span>
    </div>
    
    <div class="project-links">
      <a href="https://teardown.cafe" class="btn-primary">
        Live Site →
      </a>
      <a href="https://github.com/AimDaAlien/teardown-cafe" class="btn-secondary">
        GitHub
      </a>
    </div>
    
    <div class="project-tags">
      #hardware #repair #documentation #3d-printing
    </div>
  </div>
</div>

<script>
// Fetch stats from API
fetch('https://teardown.cafe/api/stats.json')
  .then(r => r.json())
  .then(data => {
    document.querySelector('[data-stat="teardowns"]').textContent = 
      `${data.totalTeardowns} Teardowns`;
    document.querySelector('[data-stat="devices"]').textContent = 
      `${data.deviceTypes} Device Types`;
    document.querySelector('[data-stat="photos"]').textContent = 
      `${data.totalImages}+ Photos`;
  });
</script>
```

## Phase 5: Knowledge Garden Integration

### 5.1 Create Project Note
Location: `knowledge-garden-vault/Projects/Teardown Cafe.md`

```markdown
---
tags: 
  - featured-project
  - hardware
  - documentation
  - 3d-printing
created: 2025-10-20
---

# Teardown Cafe

Personal documentation project for hardware teardowns with detailed photography and technical analysis.

**Live Site:** https://teardown.cafe  
**Repository:** [GitHub](https://github.com/AimDaAlien/teardown-cafe)  
**Tech Stack:** Astro v5.14.5, Material You 3 design system, Markdown

## Featured Teardowns

### Active Projects
- [Raspberry Pi 5 NVMe Build](https://teardown.cafe/teardowns/raspberry-pi-5-nvme-build) - 5.46TB NAS with 3D printed external cooling racks
- [Bambu Lab A1 Mini Setup](https://teardown.cafe/teardowns/bambu-lab-a1-mini-setup) - Best beginner 3D printer in 2025
- [TrueNAS Enterprise SAS Build](https://teardown.cafe/teardowns/truenas-enterprise-sas-build) - Budget $320 storage server with 10x SAS drives

### Repair Documentation
- [Moto G Stylus 2022 Screen Repair](https://teardown.cafe/teardowns/moto-g-stylus-2022-screen-repair)
- [HP EliteBook 840 G7 Frankenstein AIO](https://teardown.cafe/teardowns/hp-elitebook-g7-840-may-2023)
- [MacBook Air 2015 Internals](https://teardown.cafe/teardowns/macbook-air-2015-13inch-under-the-hood)

## Related Notes

- [[Hardware/Laptop Repair Techniques]]
- [[Homelab/Pi-hole Setup]]
- [[3D Printing/Workspace Organization]]
- [[Projects/Raspberry Pi NVMe Configuration]]
- [[Systems/ARM Architecture]]

## Project Stats

- **Total Entries:** 7
- **Device Categories:** Laptops, Smartphones, SBCs, NAS, 3D Printers
- **Started:** May 2023
- **Status:** Active development

## Technical Implementation

Built with Astro v5 for static site generation, using Markdown for content and Material You 3 design system for theming. Integrated with Obsidian vault for bidirectional knowledge linking via automated tag matching.

#projects #hardware #teardowns #documentation
```

## Phase 6: Manual Override System

### 6.1 Override Configuration File
File: `src/data/obsidian-overrides.json`

```json
{
  "bambu-lab-a1-mini-setup": {
    "additionalNotes": [
      "3D Printing/Calibration Guide",
      "Projects/Workspace Evolution"
    ],
    "excludeTags": []
  },
  "raspberry-pi-5-nvme-build": {
    "additionalNotes": [
      "Homelab/Network Configuration",
      "Systems/Linux Performance Tuning"
    ],
    "excludeTags": []
  }
}
```

Structure:
- `additionalNotes`: Array of Obsidian note paths to manually link
- `excludeTags`: Array of tags to ignore for this teardown

## Implementation Checklist

### Cursor Tasks
1. [ ] Install dependencies: `npm install glob gray-matter`
2. [ ] Update `src/content.config.ts` - add tags field
3. [ ] Create `scripts/build-obsidian-links.js`
4. [ ] Update `package.json` - add prebuild/predev scripts
5. [ ] Create `src/components/TagCloud.astro`
6. [ ] Create `src/components/RelatedObsidianNotes.astro`
7. [ ] Update teardown layout to use new components
8. [ ] Create `src/pages/api/stats.json.ts`
9. [ ] Create `public/data/` directory structure
10. [ ] Test build process end-to-end

### Aim Tasks
1. [ ] Add tags to all teardown frontmatter (copy from Phase 1.2)
2. [ ] Create `Projects/Teardown Cafe.md` in Knowledge Garden
3. [ ] Update portfolio with Teardown Cafe card (use Phase 4.2 spec)
4. [ ] Create hero image for portfolio card
5. [ ] Create `src/data/obsidian-overrides.json` (start empty)
6. [ ] Review automated matches after first build
7. [ ] Add manual overrides if needed

## File Structure After Implementation

```
teardown-cafe/
├── .cursor-specs/
│   └── portfolio-obsidian-integration.md
├── public/
│   └── data/
│       ├── obsidian-relationships.json  # Auto-generated
│       └── tag-stats.json               # Auto-generated
├── scripts/
│   └── build-obsidian-links.js          # NEW
├── src/
│   ├── components/
│   │   ├── TagCloud.astro               # NEW
│   │   └── RelatedObsidianNotes.astro   # NEW
│   ├── data/
│   │   └── obsidian-overrides.json      # NEW (start empty)
│   ├── pages/
│   │   └── api/
│   │       └── stats.json.ts            # NEW
│   └── content.config.ts                # MODIFIED
└── package.json                         # MODIFIED
```

## Testing Plan

1. **Local Build Test**
   ```bash
   npm install glob gray-matter
   npm run build
   ```
   Verify `public/data/obsidian-relationships.json` exists

2. **Component Test**
   ```bash
   npm run dev
   ```
   Navigate to any teardown, verify:
   - Tags display as pills
   - "Related in Knowledge Garden" section appears
   - Obsidian links work

3. **API Test**
   ```bash
   curl http://localhost:4321/api/stats.json
   ```
   Verify stats JSON returns correct data

4. **Portfolio Integration**
   - Add card to portfolio repo
   - Verify stats load dynamically
   - Test live site link

5. **Knowledge Garden**
   - Create project note
   - Verify backlinks work
   - Test bidirectional navigation

## Success Criteria

✅ Tags sync automatically between Obsidian and Teardown Cafe  
✅ Teardown pages show related Obsidian notes  
✅ Obsidian project note links back to teardowns  
✅ Portfolio displays Teardown Cafe with live stats  
✅ Manual overrides work for edge cases  
✅ Build completes in <5 seconds  
✅ No manual maintenance required for new teardowns
