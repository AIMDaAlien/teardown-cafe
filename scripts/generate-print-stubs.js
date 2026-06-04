#!/usr/bin/env node
/**
 * Teardown Cafe — Bulk Print Stub Generator
 *
 * Drops images into a source folder, run this script, and it:
 * 1. Copies images to public/images/prints/
 * 2. Generates markdown stubs in src/data/prints/
 * 3. Extracts dates from EXIF or filenames when possible
 * 4. Runs the image processing pipeline
 *
 * Usage:
 *   node scripts/generate-print-stubs.js [source-dir]
 *
 * Defaults to ~/Downloads/3d-prints/ if no source dir provided.
 */

import fs from 'fs'
import path from 'path'
import { glob } from 'glob'
import sharp from 'sharp'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

// ─── Configuration ───────────────────────────────────────────────────────────

const SOURCE_DIR = process.argv[2] || path.join(process.env.HOME, 'Downloads', '3d-prints')
const TARGET_IMAGE_DIR = path.resolve(process.cwd(), 'public/images/prints')
const TARGET_MD_DIR = path.resolve(process.cwd(), 'src/data/prints')

const SUPPORTED_EXTS = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.avif']

// Map common filename patterns to categories
const CATEGORY_GUESSES = {
  case: 'functional',
  holder: 'organizer',
  stand: 'organizer',
  mount: 'functional',
  cover: 'functional',
  box: 'functional',
  organizer: 'organizer',
  tray: 'organizer',
  vase: 'decorative',
  pot: 'decorative',
  figure: 'decorative',
  figurine: 'decorative',
  toy: 'toy',
  tool: 'tool',
  adapter: 'tool',
  clip: 'functional',
  bracket: 'functional',
  handle: 'functional',
}

// ─── Utilities ───────────────────────────────────────────────────────────────

function slugify(name) {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .substring(0, 60)
}

function toTitleCase(str) {
  return str
    .replace(/[-_]+/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase())
    .trim()
}

function guessCategory(filename) {
  const lower = filename.toLowerCase()
  for (const [key, cat] of Object.entries(CATEGORY_GUESSES)) {
    if (lower.includes(key)) return cat
  }
  return 'functional'
}

function formatDate(d) {
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

async function extractDate(imagePath) {
  try {
    const meta = await sharp(imagePath).metadata()
    if (meta.exif) {
      // Try to parse EXIF date
      const buf = meta.exif
      const str = buf.toString('utf-8', 0, Math.min(buf.length, 2000))
      const match = str.match(/(\d{4}):(\d{2}):(\d{2})/)
      if (match) {
        return `${match[1]}-${match[2]}-${match[3]}`
      }
    }
  } catch {
    // ignore
  }

  // Fallback: try filename patterns like IMG20250731124342
  const basename = path.basename(imagePath, path.extname(imagePath))
  const m = basename.match(/(\d{4})(\d{2})(\d{2})/)
  if (m) {
    const [_, year, month, day] = m
    if (year >= '2020' && year <= '2030') {
      return `${year}-${month}-${day}`
    }
  }

  return formatDate(new Date())
}

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }
}

// ─── Main ────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🖨️  Teardown Cafe Print Stub Generator\n')

  if (!fs.existsSync(SOURCE_DIR)) {
    console.error(`❌ Source directory not found: ${SOURCE_DIR}`)
    console.error(`   Create it and drop your print photos there, or pass a custom path:`)
    console.error(`   node scripts/generate-print-stubs.js /path/to/your/photos`)
    process.exit(1)
  }

  ensureDir(TARGET_IMAGE_DIR)
  ensureDir(TARGET_MD_DIR)

  const files = await glob(`${SOURCE_DIR}/*`, {
    absolute: true,
    nodir: true,
  })

  const imageFiles = files.filter((f) => {
    const ext = path.extname(f).toLowerCase()
    return SUPPORTED_EXTS.includes(ext)
  })

  if (imageFiles.length === 0) {
    console.error(`❌ No images found in ${SOURCE_DIR}`)
    process.exit(1)
  }

  console.log(`Found ${imageFiles.length} image(s) in ${SOURCE_DIR}\n`)

  let generated = 0
  let skipped = 0

  for (const file of imageFiles) {
    const basename = path.basename(file)
    const ext = path.extname(basename)
    const nameWithoutExt = path.basename(basename, ext)
    const slug = slugify(nameWithoutExt)
    const mdPath = path.join(TARGET_MD_DIR, `${slug}.md`)

    // Skip if markdown already exists
    if (fs.existsSync(mdPath)) {
      console.log(`  ⏭️  ${basename} — stub already exists`)
      skipped++
      continue
    }

    // Copy image
    const targetImagePath = path.join(TARGET_IMAGE_DIR, basename)
    fs.copyFileSync(file, targetImagePath)

    // Extract/guess metadata
    const pubDate = await extractDate(file)
    const title = toTitleCase(nameWithoutExt)
    const category = guessCategory(nameWithoutExt)
    const imageWebPath = `/images/prints/${basename}`

    // Generate markdown stub
    const mdContent = `---
title: '${title.replace(/'/g, "\\'")}'
image: '${imageWebPath}'
pubDate: ${pubDate}
printer: ''
filament: ''
category: '${category}'
featured: false
---
`

    fs.writeFileSync(mdPath, mdContent)
    console.log(`  ✅ ${basename} → ${slug}.md`)
    generated++
  }

  console.log(`\n${'─'.repeat(50)}`)
  console.log(`Generated: ${generated}`)
  console.log(`Skipped:   ${skipped}`)
  console.log(`\n📁 Images copied to:  ${TARGET_IMAGE_DIR}`)
  console.log(`📝 Stubs written to:   ${TARGET_MD_DIR}`)
  console.log(`\nNext steps:`)
  console.log(`  1. Edit the stubs to fill in printer, filament, and sourceUrl`)
  console.log(`  2. Mark special prints with featured: true`)
  console.log(`  3. Add body text to prints that deserve a story`)
  console.log(`  4. Run: npm run process-images`)
}

main().catch((err) => {
  console.error('Generator failed:', err)
  process.exit(1)
})
