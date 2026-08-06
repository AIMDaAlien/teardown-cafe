# The Buying Desk by Teardown Cafe

The Buying Desk is the service-first front door for Teardown Cafe. Aim checks products, listings, shortlists, and buying problems before someone spends the money.

The workbench content still lives here as Field Notes. That includes teardowns, builds, repairs, discoveries, and 3D prints.

## What the site does

- Presents 3 manual buying services: Check This, Compare These, and Choose for Me
- Builds an email draft from the request wizard without uploading or sending visitor data
- Publishes hands-on Field Notes from Astro content collections
- Keeps existing teardown, print, discovery, device, and tag routes intact
- Generates a sitemap, RSS feed, and Pagefind search index
- Uses a dark theme by default with a saved light theme option
- Loads Ubuntu and JetBrains Mono from local WOFF2 files

There are no accounts, cookies, analytics, payments, uploads, or server-side request handling.

## Content priority

The site has a deliberate order:

1. Buying Desk services
2. Field Notes such as teardowns, builds, and repairs
3. Discoveries
4. 3D prints

Prints stay available as supporting work. They arent the main reason the site exists.

## Stack

- Astro 5
- Astro Content Layer collections
- MDX support
- Sharp for local image processing
- Pagefind for static search
- Plain CSS and browser JavaScript

No frontend framework or hosted form provider is required.

## Project map

```text
src/
  components/          Shared Astro components
  data/
    teardowns/         Main Field Notes
    discoveries/       Short lessons and findings
    prints/            3D print records
  layouts/
    BaseLayout.astro   Metadata, navigation, footer, theme, and search
  pages/               Public routes and collection pages
  styles/
    global.css         Material You tokens and shared site styles
    buying-desk.css    Buying Desk page styles
  content.config.ts    Collection loaders and schemas
public/
  data/                Generated image and Obsidian relationship data
  fonts/               Self-hosted font files and licenses
  images/              Original and generated image assets
scripts/
  process-images.js        Strips metadata and makes responsive images
  build-obsidian-links.js  Builds public Obsidian relationships
```

## Local setup

Requirements:

- Node.js 18 or newer
- npm

Install and start the site:

```bash
npm install
npm run dev
```

Astro serves the site at `http://localhost:4321` by default.

## Useful commands

```bash
npm run dev
npm run lint
npx prettier --check .
npm run build
npm run preview
```

`npm run build` runs the image and Obsidian generators before Astro, then runs Pagefind afterward. Those generators can modify tracked files in `public/data/` and create image variants. Check `git status` before and after a full build.

For a build check that doesnt run those lifecycle scripts:

```bash
npx astro build
npx pagefind --site dist --output-path dist/pagefind
```

## Main routes

| Route            | Purpose                                |
| ---------------- | -------------------------------------- |
| `/`              | Buying Desk homepage                   |
| `/services`      | The 3 active services                  |
| `/request`       | Accessible 3-step email request wizard |
| `/sample-report` | Example report and evidence format     |
| `/how-it-works`  | Manual pilot process                   |
| `/field-notes`   | Main workbench collection              |
| `/discoveries`   | Short findings and lessons             |
| `/prints`        | Lower-priority 3D print gallery        |
| `/about`         | Aim and the Teardown Cafe story        |

Dynamic content keeps its existing public paths:

- `/teardowns/[id]`
- `/prints/[id]`
- `/device/[type]`
- `/tags/[tag]`

## Adding a Field Note

Create a Markdown or MDX file in `src/data/teardowns/`.

```yaml
---
title: 'Device or project name'
description: 'A short, direct summary.'
pubDate: 2026-08-06
device: laptop
difficulty: medium
heroImage: /images/example.jpg
tags:
  - repair
  - laptop
---
```

Valid device and difficulty values live in `src/content.config.ts`. The filename becomes the public article ID.

Keep published writing in Aim's voice. Use short sentences, contractions, regular hyphens, and no semicolons or em dashes. The full writing guide is `/Users/aim/Documents/VOICE.md` on Aim's machine.

## Adding a discovery

Create a Markdown or MDX file in `src/data/discoveries/` with a title, device, finding, date, and severity. Discoveries appear below the main Field Notes and keep their own page at `/discoveries`.

## Adding a print

Create a Markdown file in `src/data/prints/` or run:

```bash
npm run generate-print-stubs
```

Print categories are optional. Use one only when it tells the visitor something useful. The old catch-all `functional` category was removed because it didnt help anyone find anything.

## Images

Put source images in `public/images/` and reference them with paths such as `/images/example.jpg`.

Run this when new source images are ready:

```bash
npm run process-images
```

The script strips image metadata, writes cleaned copies, creates 400px, 800px, and 1200px WebP variants, then updates `public/data/image-manifest.json`.

Review every source image before publishing. The script removes embedded metadata. It cannot tell whether private information is visible inside the picture.

## Obsidian links

`scripts/build-obsidian-links.js` reads Aim's local Obsidian vault and matches public notes to teardowns by tags or explicit `relatedNotes` entries.

Run it with:

```bash
node scripts/build-obsidian-links.js
```

It writes:

- `public/data/obsidian-relationships.json`
- `public/data/tag-stats.json`

The script expects the vault at `~/Documents/Obsidian Notes Vault`. It skips links to notes marked private or unpublished in the garden manifest.

## Request wizard

The request form is intentionally static. It validates the answers, builds a review summary, and opens an encoded email draft addressed to:

- To: `amasud.tech@gmail.com`
- CC: `amasudtech@gmail.com`

Nothing is sent until the visitor presses Send in their email app. The copy button is the fallback when a device cannot open a draft.

## Fonts

Ubuntu and JetBrains Mono are stored in `public/fonts/` and declared with `@font-face` in `src/styles/global.css`. The browser doesnt contact Google Fonts.

The downloaded font licenses are stored beside the font files.

## Deployment

Astro writes the static site to `dist/`. The canonical production URL is configured as `https://teardown.cafe` in `astro.config.mjs`.

This repository does not contain a deployment workflow. Publishing depends on the external host that serves `dist/`.
