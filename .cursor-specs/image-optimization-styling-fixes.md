# Vercel Image Optimization & Styling Fixes

## 1. Vercel Image Caching

Vercel automatically caches images but we can optimize further.

### Image Component (Recommended)
Use `@astrojs/vercel/image` for automatic optimization:

```bash
npm install @astrojs/vercel
```

**astro.config.mjs:**
```js
import { defineConfig } from 'astro/config';
import vercel from '@astrojs/vercel/static';

export default defineConfig({
  adapter: vercel(),
  image: {
    service: {
      entrypoint: '@astrojs/vercel/image',
      config: {
        cacheControl: 'max-age=31536000,immutable'
      }
    }
  }
});
```

### Update Homepage Cards
Replace `<img>` with `<Image>` component:

```astro
---
import { Image } from 'astro:assets';
---

<Image 
  src={teardown.data.heroImage}
  alt={teardown.data.title}
  width={600}
  height={400}
  format="webp"
  quality={80}
  loading="lazy"
/>
```

Benefits:
- Auto WebP conversion
- Responsive images
- CDN caching
- Lazy loading

## 2. Decorative Elements Hover Fix

**File:** `src/components/CircuitAccents.astro` (or wherever decorative elements are)

Current issue: Hover makes elements brighter (hard to see in light mode)

**Fix:**
```css
.decorative-element {
  /* Base state */
  opacity: 0.6;
  filter: blur(8px);
  
  /* Light mode */
  background: radial-gradient(circle, rgba(147, 51, 234, 0.3) 0%, transparent 70%);
  
  /* Dark mode */
  @media (prefers-color-scheme: dark) {
    background: radial-gradient(circle, rgba(167, 139, 250, 0.4) 0%, transparent 70%);
  }
}

.decorative-element:hover {
  /* Light mode - darker glow */
  filter: blur(12px) brightness(0.7);
  background: radial-gradient(circle, rgba(147, 51, 234, 0.5) 0%, transparent 70%);
  
  /* Dark mode - lighter glow */
  @media (prefers-color-scheme: dark) {
    filter: blur(12px) brightness(1.3);
    background: radial-gradient(circle, rgba(167, 139, 250, 0.6) 0%, transparent 70%);
  }
}
```

## 3. Background Color - Lavender

**File:** `src/styles/global.css`

Replace white backgrounds with lavender:

```css
:root {
  /* Light mode */
  --background: 245 240 255; /* Lavender instead of pure white */
  --surface: 250 247 255;
  --surface-container: 240 235 250;
  --surface-container-high: 235 230 245;
  --surface-container-low: 248 245 252;
}

[data-theme="dark"] {
  /* Keep dark mode as-is or adjust if needed */
  --background: 15 10 25;
  --surface: 20 15 30;
  /* ... */
}

body {
  background: rgb(var(--background));
  color: rgb(var(--on-background));
}
```

Lavender values:
- Very light: `rgb(245, 240, 255)` - subtle hint
- Light: `rgb(240, 235, 250)` - noticeable but soft
- Medium: `rgb(235, 230, 245)` - clear lavender

## 4. Cursor Context Window

Cursor has smaller context than Claude. Strategies:

**Break tasks into smaller chunks:**
```
Bad:  "Implement search, filters, and pagination"
Good: "Add search bar component with state management"
      (then) "Add filter dropdowns"
      (then) "Add pagination controls"
```

**Reference specific files:**
```
"Update src/components/CircuitAccents.astro line 45-60"
```

**Use specs more:**
- Claude writes detailed spec
- Cursor implements one section at a time
- Avoids context overload

## Implementation Order

1. **Background color** (easiest, instant visual improvement)
2. **Hover effects** (styling fix, no new dependencies)
3. **Vercel Image** (requires astro.config change, test thoroughly)

## Testing Checklist

- [ ] Light mode background is lavender
- [ ] Dark mode background unchanged
- [ ] Decorative hover darker in light mode
- [ ] Decorative hover lighter in dark mode
- [ ] Images load from Vercel CDN
- [ ] WebP format served
- [ ] No broken images
