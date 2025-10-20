// Astro 5 Content Layer API Configuration
import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const teardowns = defineCollection({
  // New Content Layer API: uses loader instead of type
  loader: glob({
    pattern: '**/*.{md,mdx}',
    base: './src/data/teardowns'
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
      'other'
    ]),
    difficulty: z.enum(['easy', 'medium', 'hard']),
    heroImage: z.string().optional(),
    video: z.string().optional(),
  }),
});

export const collections = { teardowns };
