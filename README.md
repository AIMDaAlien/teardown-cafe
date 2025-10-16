# ☕ Teardown Cafe

A modern device teardown blog built with **Astro 5** and Material You 3 design system.

## 🏗️ Architecture Overview

This project uses **Astro 5's Content Layer API** (released December 2024) for content management. This is a significant departure from legacy content collections.

### Key Astro 5 Changes Implemented

1. **Content configuration location**: `src/content.config.ts` (moved from `src/content/config.ts`)
2. **Loader-based collections**: Uses `glob()` loader instead of `type: 'content'`
3. **Content location**: `src/data/teardowns/` (can be anywhere on filesystem)
4. **API changes**:
   - `entry.slug` → `entry.id`
   - `entry.render()` → `render(entry)` as separate import
   - `[slug].astro` → `[id].astro` for dynamic routes

## 📁 Project Structure

```
teardown-cafe/
├── src/
│   ├── content.config.ts          # Astro 5 Content Layer config (NEW LOCATION)
│   ├── data/
│   │   └── teardowns/             # Teardown markdown files (NEW LOCATION)
│   │       └── *.md
│   ├── layouts/
│   │   └── BaseLayout.astro       # Site wrapper with Material You 3
│   ├── pages/
│   │   ├── index.astro            # Homepage grid
│   │   ├── about.astro            # About page
│   │   └── teardowns/
│   │       └── [id].astro         # Dynamic teardown pages (uses id, not slug)
│   ├── styles/
│   │   └── global.css             # Material You 3 design tokens
│   └── env.d.ts
├── public/
│   └── images/                    # Static images
├── astro.config.mjs
├── package.json
├── tsconfig.json
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ 
- npm or pnpm

### Installation

```bash
cd teardown-cafe
npm install
```

### Development

```bash
npm run dev
```

Server runs at `http://localhost:4321`

### Building for Production

```bash
npm run build
npm run preview
```

## ✍️ Adding New Teardowns

### 1. Create Markdown File

Create a new `.md` or `.mdx` file in `src/data/teardowns/`:

```markdown
---
title: "Device Name Teardown"
description: "Brief description of what you're tearing down"
pubDate: 2025-10-15
device: laptop  # Options: monitor, laptop, smartphone, raspberry-pi, nas, mechanical-keyboard, other
difficulty: medium  # Options: easy, medium, hard
heroImage: /images/your-image.jpg  # Optional
---

## Your Content Here

Write your teardown documentation in markdown...
```

### 2. Add Images

Place images in `public/images/` directory. Reference them as `/images/filename.jpg` in markdown.

**Privacy Note**: Images should have EXIF metadata stripped before upload to protect location data.

### 3. Build

The Content Layer API automatically detects new files. Just refresh the dev server or rebuild.

## 🎨 Design System

This site uses **Material You 3** design tokens with a periwinkle/lavender purple color scheme.

### Color Tokens

- Primary: `#C4ACFA` (Periwinkle)
- Surface: `#131218` (Dark background)
- All tokens defined in `src/styles/global.css`

### Typography

- Font: Inter (Google Fonts)
- Scale: Material You 3 typescale system

### Elevation

5 elevation levels using Material You 3 shadow system

## 🔧 Configuration

### Astro Config (`astro.config.mjs`)

```javascript
export default defineConfig({
  site: 'https://teardown.cafe',  // Update to your domain
  integrations: [mdx(), sitemap()],
});
```

### Content Schema (`src/content.config.ts`)

Modify the schema to add custom frontmatter fields:

```typescript
schema: z.object({
  title: z.string(),
  description: z.string(),
  pubDate: z.coerce.date(),
  device: z.enum(['monitor', 'laptop', /* add more */]),
  difficulty: z.enum(['easy', 'medium', 'hard']),
  heroImage: z.string().optional(),
  // Add custom fields here
}),
```

## 📦 Dependencies

- **astro**: `^5.14.5` - Core framework
- **@astrojs/mdx**: `^4.3.7` - MDX support (required for Astro 5)
- **@astrojs/sitemap**: `^3.6.0` - Automatic sitemap generation
- **sharp**: `^0.34.4` - Image optimization

## 🚨 Troubleshooting

### Content not appearing?

1. Verify file is in `src/data/teardowns/`
2. Check frontmatter matches schema in `src/content.config.ts`
3. Restart dev server: `npm run dev`
4. Clear Astro cache: `rm -rf .astro`

### "Cannot find module 'astro:content'"?

Run `npm install` to ensure all dependencies are installed.

### Build errors about MDX?

Ensure `@astrojs/mdx` is at least version 4.0.0 (required for Astro 5).

## 📚 Resources

- [Astro 5 Documentation](https://docs.astro.build/)
- [Content Layer API Reference](https://docs.astro.build/en/reference/content-loader-reference/)
- [Astro 5 Upgrade Guide](https://docs.astro.build/en/guides/upgrade-to/v5/)
- [Material You 3 Guidelines](https://m3.material.io/)

## 🔗 Obsidian Knowledge Garden Integration

### Bidirectional Linking

Teardowns can link to your Obsidian notes using the `relatedNotes` frontmatter field:

```yaml
relatedNotes:
  - "Homelab/Pi-hole Setup"
  - "Projects/Raspberry Pi NVMe Configuration"
```

These render as clickable links to your published knowledge garden.

### Automatic Index Updates

Run `./sync-to-obsidian.sh` after committing teardowns to automatically update your Obsidian vault with:
- Complete teardown index
- Statistics and categories
- Bidirectional links
- Auto-generated metadata

See [WORKFLOW.md](./WORKFLOW.md) for complete integration details.

## 🔒 Privacy Considerations

- All uploaded images should have EXIF metadata stripped
- No analytics tracking by default
- Static site = minimal attack surface
- No server-side user tracking

## 📄 License

MIT

## 🙏 Credits

Built with [Astro](https://astro.build) and designed following [Material You 3](https://m3.material.io/) principles.
