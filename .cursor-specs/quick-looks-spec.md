# Quick Looks - Single Photo Items

For items with 1-2 photos not worthy of full teardowns.

## Implementation Option 1: Dedicated Quick Looks Page

**Route:** `/quick-looks`

**Structure:**
```astro
// src/pages/quick-looks.astro
const items = [
  {
    title: 'Tozo Wireless Charger',
    image: '/images/quick-looks/tozo-charger.jpg',
    description: 'Basic wireless charging pad',
    tags: ['charging', 'wireless']
  },
  {
    title: '2012 iPod Touch',
    image: '/images/quick-looks/ipod-touch-2012.jpg',
    description: 'Retro iOS device from before streaming era',
    tags: ['apple', 'legacy', 'ipod']
  },
  {
    title: 'Realme Smartwatch + Hairband Strap',
    image: '/images/quick-looks/realme-hairband.jpg',
    description: 'Budget smartwatch with improvised strap solution',
    tags: ['wearable', 'diy-mod']
  }
];
```

**Display:** Masonry grid, click to expand with description.

## Implementation Option 2: Sidebar/Widget on Homepage

**Location:** Right sidebar or bottom of homepage

**Title:** "📸 Quick Looks"

**Format:** Compact cards (3-4 visible, "View all →" link)

## Implementation Option 3: Part of Teardowns Collection

**Add field:** `quickLook: true` to frontmatter

**Filter:** Separate page showing only quick looks

**Benefits:** Same content system, just flagged differently

## Recommendation: Option 1

- Clean separation from full teardowns
- Fast to build (single page)
- Easy to add more items
- No schema changes needed

## Cursor Spec

```markdown
Create /quick-looks page:
1. Masonry grid layout (2-3 columns)
2. Each item: image + title + 1-line description
3. Click to expand (lightbox or modal)
4. Filterable by tags
5. Link from homepage: "Quick Looks" in nav

Style: Match Material You 3 design system
```

## Directory Structure

```
public/images/quick-looks/
  tozo-charger.jpg
  ipod-touch-2012.jpg
  realme-hairband.jpg
```
