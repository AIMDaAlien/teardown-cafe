// Astro 5 Content Layer API Configuration
import { defineCollection, z } from 'astro:content'
import { glob } from 'astro/loaders'

const teardowns = defineCollection({
  // New Content Layer API: uses loader instead of type
  loader: glob({
    pattern: '**/*.{md,mdx}',
    base: './src/data/teardowns',
  }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    device: z.enum([
      'monitor',
      'laptop',
      'smartphone',
      'raspberry-pi',
      'nas',
      'mechanical-keyboard',
      '3d-printer',
      'other',
    ]),
    difficulty: z.enum(['easy', 'medium', 'hard']),
    heroImage: z.string().optional(),
    video: z.string().optional(),
    tags: z.array(z.string()).optional(),
    relatedNotes: z.array(z.string()).optional(),
  }),
})

const discoveries = defineCollection({
  loader: glob({
    pattern: '**/*.{md,mdx}',
    base: './src/data/discoveries',
  }),
  schema: z.object({
    title: z.string(),
    device: z.string(),
    finding: z.string(),
    pubDate: z.coerce.date(),
    severity: z.enum(['critical', 'warning', 'insight']),
    icon: z.string().optional(), // emoji icon
    relatedTeardown: z.string().optional(), // slug of related teardown
  }),
})

export const collections = { teardowns, discoveries }
