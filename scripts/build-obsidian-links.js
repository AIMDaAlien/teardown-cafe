import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import { glob } from 'glob'

const OBSIDIAN_VAULT = process.env.HOME + '/Documents/Obsidian Notes Vault'
const TEARDOWN_DIR = './src/data/teardowns'
const OUTPUT_FILE = './public/data/obsidian-relationships.json'
const OVERRIDES_FILE = './src/data/obsidian-overrides.json'
const MANIFEST_FILE = OBSIDIAN_VAULT + '/garden-manifest.json'
const GARDEN_BASE = 'https://aimdaalien.github.io/First-Portfolio-Iteration/garden-terminal.html'

// Load garden manifest for privacy + garden_path mapping
function loadManifest() {
  if (!fs.existsSync(MANIFEST_FILE)) {
    console.warn('⚠ Garden manifest not found, skipping privacy filter and garden_path lookup')
    return { metadata: {} }
  }
  return JSON.parse(fs.readFileSync(MANIFEST_FILE, 'utf-8'))
}

function isPublicNote(meta) {
  if (!meta) return true // default to public if no metadata
  if (meta.published_to_garden === false) return false
  if (meta.visibility === 'private') return false
  return true
}

function getGardenPath(vaultRelativePath, meta) {
  if (meta && meta.garden_path) return meta.garden_path
  // Fallback: strip .md extension for URL (garden terminal handles paths with or without .md)
  return vaultRelativePath
}

function extractInlineHashtags(content) {
  const tags = new Set()
  // Skip YAML frontmatter
  const body = content.replace(/^---\n[\s\S]*?\n---\n?/m, '')
  // Match Obsidian-style inline hashtags: #tag-name, #tag_name
  // Avoid matching hex colors (#fff), markdown headings (###), or URLs
  const hashtagPattern = /(?:^|\s|[^\w#])#([a-zA-Z][a-zA-Z0-9_-]*)/g
  let match
  while ((match = hashtagPattern.exec(body)) !== null) {
    tags.add(match[1].toLowerCase())
  }
  return Array.from(tags)
}

async function scanObsidianNotes(manifestMeta) {
  const notes = new Map()
  const files = await glob(`${OBSIDIAN_VAULT}/**/*.md`)

  for (const file of files) {
    const content = fs.readFileSync(file, 'utf-8')
    const { data } = matter(content)
    const vaultRelativePath = path.relative(OBSIDIAN_VAULT, file)
    const meta = manifestMeta[vaultRelativePath]

    // Privacy filter
    if (!isPublicNote(meta)) continue

    const allTags = new Set()

    // YAML frontmatter tags
    if (data.tags) {
      const yamlTags = Array.isArray(data.tags) ? data.tags : [data.tags]
      yamlTags.forEach((tag) => {
        const normalized = String(tag).replace('#', '').toLowerCase().trim()
        if (normalized) allTags.add(normalized)
      })
    }

    // Inline hashtags from body
    const inlineTags = extractInlineHashtags(content)
    inlineTags.forEach((tag) => allTags.add(tag))

    if (allTags.size === 0) continue

    const gardenPath = getGardenPath(vaultRelativePath, meta)
    const title = data.title || path.basename(file, '.md')

    allTags.forEach((tag) => {
      if (!notes.has(tag)) notes.set(tag, [])
      notes.get(tag).push({
        title,
        path: gardenPath,
        vaultPath: vaultRelativePath,
      })
    })
  }

  return notes
}

async function scanTeardowns() {
  const teardowns = new Map()
  const relatedNotes = new Map() // slug -> array of vault paths
  const files = await glob(`${TEARDOWN_DIR}/*.md`)

  for (const file of files) {
    const content = fs.readFileSync(file, 'utf-8')
    const { data } = matter(content)

    const slug = path.basename(file, '.md')

    if (data.tags) {
      data.tags.forEach((tag) => {
        const normalizedTag = tag.toLowerCase()
        if (!teardowns.has(normalizedTag)) teardowns.set(normalizedTag, [])
        teardowns.get(normalizedTag).push({
          title: data.title,
          slug: slug,
        })
      })
    }

    if (data.relatedNotes && Array.isArray(data.relatedNotes)) {
      relatedNotes.set(slug, data.relatedNotes)
    }
  }

  return { teardowns, relatedNotes }
}

function makeGardenUrl(gardenPath) {
  return `${GARDEN_BASE}?note=${encodeURIComponent(gardenPath)}`
}

async function buildRelationships() {
  const manifest = loadManifest()
  const manifestMeta = manifest.metadata || {}

  const obsidianByTag = await scanObsidianNotes(manifestMeta)
  const { teardowns: teardownsByTag, relatedNotes: teardownRelatedNotes } = await scanTeardowns()

  // Load overrides
  let overrides = {}
  if (fs.existsSync(OVERRIDES_FILE)) {
    overrides = JSON.parse(fs.readFileSync(OVERRIDES_FILE, 'utf-8'))
  }

  const relationships = {}
  const tagStats = { total: 0, matched: 0, tags: {} }

  // Match tags
  for (const [tag, notes] of obsidianByTag) {
    tagStats.total++
    if (teardownsByTag.has(tag)) {
      tagStats.matched++
      relationships[tag] = {
        obsidianNotes: notes.map((n) => ({
          title: n.title,
          path: n.path,
          url: makeGardenUrl(n.path),
        })),
        teardowns: teardownsByTag.get(tag).map((t) => ({
          title: t.title,
          slug: t.slug,
          url: `/teardowns/${t.slug}`,
        })),
      }

      tagStats.tags[tag] = {
        obsidian: notes.length,
        teardowns: teardownsByTag.get(tag).length,
      }
    }
  }

  // Helper to add a note connection to a slug
  function addNoteConnection(slug, notePath) {
    const fullPath = path.join(OBSIDIAN_VAULT, notePath)
    // Skip if file doesn't exist on disk
    if (!fs.existsSync(fullPath)) return

    const meta = manifestMeta[notePath]
    // Skip private/unpublished notes
    if (!isPublicNote(meta)) return

    const tag = `manual-${slug}`
    if (!relationships[tag])
      relationships[tag] = { obsidianNotes: [], teardowns: [] }

    // Avoid duplicates within this slug's manual connections
    const existingPaths = new Set(relationships[tag].obsidianNotes.map((n) => n.path))
    const gardenPath = getGardenPath(notePath, meta)
    if (existingPaths.has(gardenPath)) return

    const title = meta?.title || path.basename(notePath, '.md')

    relationships[tag].obsidianNotes.push({
      title,
      path: gardenPath,
      url: makeGardenUrl(gardenPath),
    })
  }

  // Process relatedNotes from teardown frontmatter
  for (const [slug, notePaths] of teardownRelatedNotes) {
    for (const notePath of notePaths) {
      // Append .md if not present for vault path lookup
      const vaultPath = notePath.endsWith('.md') ? notePath : `${notePath}.md`
      addNoteConnection(slug, vaultPath)
    }
  }

  // Apply overrides
  for (const [slug, override] of Object.entries(overrides)) {
    if (override.additionalNotes) {
      for (const notePath of override.additionalNotes) {
        addNoteConnection(slug, notePath)
      }
    }
  }

  // Ensure output directory exists
  const outputDir = path.dirname(OUTPUT_FILE)
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true })
  }

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(relationships, null, 2))
  fs.writeFileSync(
    './public/data/tag-stats.json',
    JSON.stringify(tagStats, null, 2)
  )

  console.log(`✓ Generated ${OUTPUT_FILE}`)
  console.log(`✓ Matched ${tagStats.matched}/${tagStats.total} tags`)
}

buildRelationships().catch(console.error)
