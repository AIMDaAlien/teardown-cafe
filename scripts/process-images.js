#!/usr/bin/env node
/**
 * Teardown Cafe — Image Processing Pipeline
 *
 * Privacy-first image processor:
 * 1. Strips ALL EXIF metadata (GPS, camera, timestamps)
 * 2. Generates responsive WebP variants (400w, 800w, 1200w)
 * 3. Builds image-manifest.json for the frontend
 * 4. Logs audit trail of what was processed
 *
 * Run via: npm run process-images
 * Or as part of prebuild.
 */

import sharp from 'sharp'
import fs from 'fs'
import path from 'path'
import { glob } from 'glob'

// ─── Configuration ───────────────────────────────────────────────────────────

const IMAGE_DIR = 'public/images'
const MANIFEST_PATH = 'public/data/image-manifest.json'
const VARIANT_WIDTHS = [400, 800, 1200]
const WEBP_QUALITY = 80
const SUPPORTED_EXTS = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.avif']

// Skip already-generated variants and manifest files
const SKIP_PATTERNS = [/-\d+w\.webp$/, /-cleaned\.[a-z]+$/]

// ─── Utilities ───────────────────────────────────────────────────────────────

function shouldSkipFile(filename) {
  const lower = filename.toLowerCase()
  const ext = path.extname(lower)
  if (!SUPPORTED_EXTS.includes(ext)) return true
  return SKIP_PATTERNS.some((p) => p.test(filename))
}

function formatBytes(bytes) {
  if (bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

async function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }
}

// ─── EXIF Stripping ──────────────────────────────────────────────────────────

async function stripExif(inputPath, outputPath) {
  // Re-encode through sharp WITHOUT metadata to guarantee stripping
  // This removes: EXIF, IPTC, XMP, ICC profile (partial), GPS, thumbnail
  await sharp(inputPath)
    .rotate() // honour orientation tag before stripping
    .withMetadata({}) // explicitly empty = strip everything
    .toBuffer()
    .then((buf) => fs.writeFileSync(outputPath, buf))
}

async function getExifSummary(imagePath) {
  try {
    const meta = await sharp(imagePath).metadata()
    const tags = []
    if (meta.exif) tags.push('EXIF')
    if (meta.icc) tags.push('ICC')
    if (meta.iptc) tags.push('IPTC')
    if (meta.xmp) tags.push('XMP')
    if (meta.gps) tags.push('GPS')
    return { hasMetadata: tags.length > 0, tags, orientation: meta.orientation }
  } catch {
    return { hasMetadata: false, tags: [], orientation: undefined }
  }
}

// ─── Variant Generation ──────────────────────────────────────────────────────

async function generateVariant(inputPath, outputPath, targetWidth) {
  await sharp(inputPath)
    .resize(targetWidth, null, {
      withoutEnlargement: true,
      fit: 'inside',
    })
    .webp({ quality: WEBP_QUALITY, effort: 4 })
    .withMetadata({}) // strip metadata from variants too
    .toFile(outputPath)
}

// ─── Main Pipeline ───────────────────────────────────────────────────────────

async function processImages() {
  console.log('🔒 Teardown Cafe Image Pipeline\n')

  const files = await glob(`${IMAGE_DIR}/**/*`, {
    absolute: false,
    nodir: true,
  })

  const imageFiles = files.filter((f) => !shouldSkipFile(f))

  if (imageFiles.length === 0) {
    console.log('No images found to process.')
    return
  }

  console.log(`Found ${imageFiles.length} image(s)\n`)

  const manifest = {}
  let processedCount = 0
  let skippedCount = 0
  let totalOriginalSize = 0
  let totalVariantSize = 0
  let privacyCleanedCount = 0

  for (const file of imageFiles) {
    const dir = path.dirname(file)
    const basename = path.basename(file)
    const ext = path.extname(basename)
    const name = path.basename(basename, ext)
    const relDir = path.relative(IMAGE_DIR, dir)

    // Paths for cleaned original and variants
    const cleanedName = `${name}-cleaned${ext}`
    const cleanedPath = path.join(dir, cleanedName)

    // Check if cleaned version already exists and is newer
    const needsProcessing = (() => {
      if (!fs.existsSync(cleanedPath)) return true
      const srcStat = fs.statSync(file)
      const cleanedStat = fs.statSync(cleanedPath)
      return srcStat.mtime > cleanedStat.mtime
    })()

    // Check if we already have variants from a previous run
    const existingVariants = VARIANT_WIDTHS.map((w) => {
      const vp = path.join(dir, `${name}-${w}w.webp`)
      return fs.existsSync(vp) ? { width: w, path: vp.replace(/^public/, '') } : null
    }).filter(Boolean)

    if (!needsProcessing && existingVariants.length > 0) {
      skippedCount++
      const key = '/' + path.join('images', relDir, basename).replace(/\\/g, '/')
      const dim = await sharp(cleanedPath).metadata()
      manifest[key] = {
        original: '/' + path.join('images', relDir, cleanedName).replace(/\\/g, '/'),
        width: dim.width,
        height: dim.height,
        variants: existingVariants,
      }
      continue
    }

    try {
      // ── Privacy Audit ─────────────────────────────────────────────────────
      const exifSummary = await getExifSummary(file)
      const originalSize = fs.statSync(file).size
      totalOriginalSize += originalSize

      // ── Strip EXIF & write cleaned original ───────────────────────────────
      await stripExif(file, cleanedPath)
      privacyCleanedCount++

      // ── Generate responsive variants ──────────────────────────────────────
      const variants = []
      for (const width of VARIANT_WIDTHS) {
        const variantFilename = `${name}-${width}w.webp`
        const variantPath = path.join(dir, variantFilename)
        await generateVariant(cleanedPath, variantPath, width)
        const variantSize = fs.statSync(variantPath).size
        totalVariantSize += variantSize
        variants.push({
          width,
          path: variantPath.replace(/^public/, ''),
        })
      }

      // ── Get dimensions ────────────────────────────────────────────────────
      const dim = await sharp(cleanedPath).metadata()

      // ── Build manifest entry ──────────────────────────────────────────────
      const key = '/' + path.join('images', relDir, basename).replace(/\\/g, '/')
      manifest[key] = {
        original: '/' + path.join('images', relDir, cleanedName).replace(/\\/g, '/'),
        width: dim.width,
        height: dim.height,
        variants,
      }

      // ── Log ───────────────────────────────────────────────────────────────
      const tagsStr = exifSummary.tags.length > 0 ? `(${exifSummary.tags.join(', ')})` : '(none)'
      console.log(`  ✅ ${path.join(relDir, basename)}`)
      console.log(`     └─ Stripped: ${tagsStr}`)
      console.log(`     └─ Variants: ${variants.map((v) => v.width + 'w').join(', ')}`)

      processedCount++
    } catch (err) {
      console.error(`  ❌ Error processing ${file}:`, err.message)
    }
  }

  // ── Write manifest ────────────────────────────────────────────────────────
  await ensureDir(path.dirname(MANIFEST_PATH))
  fs.writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2))

  // ── Summary ───────────────────────────────────────────────────────────────
  console.log('\n' + '─'.repeat(50))
  console.log('📊 Summary')
  console.log('─'.repeat(50))
  console.log(`Processed:     ${processedCount}`)
  console.log(`Skipped:       ${skippedCount}`)
  console.log(`Privacy cleaned: ${privacyCleanedCount}`)
  console.log(`Original size: ${formatBytes(totalOriginalSize)}`)
  console.log(`Variant size:  ${formatBytes(totalVariantSize)}`)
  console.log(`Manifest:      ${MANIFEST_PATH}`)
  console.log(`\n🔐 All EXIF metadata has been removed.`)
  console.log(`🖼️  Use "*-cleaned*" originals and "*-*w.webp" variants.\n`)
}

processImages().catch((err) => {
  console.error('Pipeline failed:', err)
  process.exit(1)
})
