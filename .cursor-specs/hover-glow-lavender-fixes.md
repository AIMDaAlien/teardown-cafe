# Styling Fixes - Hover Glow & Lavender Background

## Issue 1: Circuit Accent Hover Too Bright

**File:** `src/components/CircuitAccents.astro`
**Line:** ~160-165

Current hover effect uses `brightness(1.3)` - makes elements too bright in light mode.

### Fix:
```css
.circuit-accent:hover {
  opacity: 1 !important;
  transition: opacity 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), 
              filter 0.4s cubic-bezier(0.34, 1.56, 0.64, 1),
              transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Light mode - darker glow */
.circuit-accent:hover {
  filter: drop-shadow(0 0 16px rgba(107, 76, 147, 0.6)) 
          drop-shadow(0 4px 8px rgba(107, 76, 147, 0.4))
          brightness(0.8);
}

/* Dark mode - lighter glow */
[data-theme="dark"] .circuit-accent:hover {
  filter: drop-shadow(0 0 20px rgba(212, 188, 255, 0.9)) 
          drop-shadow(0 6px 12px rgba(212, 188, 255, 0.5))
          brightness(1.3);
}

/* Auto dark mode support */
@media (prefers-color-scheme: dark) {
  .circuit-accent:hover {
    filter: drop-shadow(0 0 20px rgba(212, 188, 255, 0.9)) 
            drop-shadow(0 6px 12px rgba(212, 188, 255, 0.5))
            brightness(1.3);
  }
}
```

## Issue 2: Background More Lavender

**File:** `src/styles/global.css`
**Lines:** Light theme section (~88-103)

Current light background: `#FEF7FF` (very subtle lavender)
Change to: `#F5F0FF` (more noticeable lavender)

### Fix:
```css
[data-theme="light"] {
  /* Background - More lavender */
  --md-sys-color-background: #F5F0FF; /* Changed from #FEF7FF */
  --md-sys-color-on-background: #1C1B1F;
  
  /* Surface Colors - Adjust to match */
  --md-sys-color-surface: #F5F0FF; /* Changed from #FEF7FF */
  --md-sys-color-on-surface: #1C1B1F;
  
  --md-sys-color-surface-container-lowest: #FAF7FF;
  --md-sys-color-surface-container-low: #F2EDFA;
  --md-sys-color-surface-container: #EDE8F4;
  --md-sys-color-surface-container-high: #E8E3EE;
  --md-sys-color-surface-container-highest: #E3DDE9;
}
```

Color progression:
- Background: `#F5F0FF` (lightest lavender)
- Container-lowest: `#FAF7FF` (slightly elevated)
- Container-low: `#F2EDFA` (more depth)
- Container: `#EDE8F4` (standard elevation)
- Container-high: `#E8E3EE` (higher elevation)
- Container-highest: `#E3DDE9` (highest elevation)

## Testing

**Light mode:**
1. Hover circuit accents → should glow darker purple
2. Background should have noticeable lavender tint
3. Cards should have subtle lavender hierarchy

**Dark mode:**
1. Hover circuit accents → should glow bright purple (current behavior)
2. Background unchanged

## Implementation Notes

- Don't change any dark mode styles
- Only update light mode hover and backgrounds
- Test on both light/dark theme toggles
- Verify accessibility contrast ratios remain WCAG compliant
