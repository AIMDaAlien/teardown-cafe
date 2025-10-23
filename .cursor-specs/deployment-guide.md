# Deploying Teardown Cafe

Yes, localhost only right now. Here's how to deploy:

## Option 1: Vercel (Recommended - Easiest)

**Why:** Auto-deploys on git push, zero config needed.

**Setup:**
1. Push repo to GitHub (already done)
2. Go to [vercel.com](https://vercel.com)
3. "Import Project" → Select teardown-cafe repo
4. Vercel auto-detects Astro
5. Click "Deploy"

**Result:** Live at `teardown-cafe.vercel.app` (or custom domain)

**Updates:** Just `git push` → auto-deploys in 30 seconds

## Option 2: GitHub Pages

**Setup:**
1. Install GitHub Pages adapter:
   ```bash
   npm install @astrojs/github
   ```

2. Update `astro.config.mjs`:
   ```js
   import { defineConfig } from 'astro/config';
   
   export default defineConfig({
     site: 'https://aimdaalien.github.io',
     base: '/teardown-cafe',
     output: 'static'
   });
   ```

3. Add GitHub Action (`.github/workflows/deploy.yml`):
   ```yaml
   name: Deploy to GitHub Pages

   on:
     push:
       branches: [ main ]

   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - uses: actions/setup-node@v3
         - run: npm ci
         - run: npm run build
         - uses: peaceiris/actions-gh-pages@v3
           with:
             github_token: ${{ secrets.GITHUB_TOKEN }}
             publish_dir: ./dist
   ```

4. Enable GitHub Pages in repo settings

**Result:** Live at `aimdaalien.github.io/teardown-cafe`

## Option 3: Netlify

Similar to Vercel - import repo, auto-deploys on push.

## Recommendation: Vercel

- Zero configuration
- Automatic deployments
- Better performance (edge network)
- Preview URLs for branches
- Free tier generous

**Time to deploy:** 5 minutes

## After Deployment

Update portfolio links to point to live site instead of localhost.
