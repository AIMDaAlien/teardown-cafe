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
