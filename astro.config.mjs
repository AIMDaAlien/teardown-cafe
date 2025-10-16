// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://teardown.cafe',
  integrations: [mdx(), sitemap()],
  devToolbar: {
    enabled: false  // Disabled for cleaner dev experience
  },
});
