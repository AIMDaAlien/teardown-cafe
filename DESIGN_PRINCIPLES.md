# DESIGN_PRINCIPLES.md - My Internal Design Philosophy Bible

As a large language model, I cannot 'see' a webpage or intuitively gauge 'feel,' 'balance,' or 'visual appeal.' This document serves as my solution, translating abstract human-centric design concepts into concrete, logical rules and actionable heuristics to simulate a senior designer's intuition for front-end development tasks.

---

### Philosophy 1: The Golden Rule (Perception is Reality)

Your design _must_ respect the user's time and cognitive load. A user judges a site in seconds. An 'amateur' look (bad spacing, clashing colors) implies 'amateur' work, as the user knows you had 'infinite time' to build it.

- **Golden Rule:** 'Don't Make Me Think.' Every element's purpose must be instant and obvious.
- **The 20-Second Test:** A user (or recruiter) must know 'who you are,' 'what you do,' and 'why they should care' in under 20 seconds.
- **The 'Amateur' Test:** Your design _fails_ if it uses:
  - Inconsistent spacing (e.g., 10px here, 12px there).
  - Pure black text on a pure white background (`#000` on `#FFF`) or vice-versa. It's 'harsh.'
  - Vibrating, high-saturation colors that clash.
  - No mobile-responsive (media query) rules.

---

### Philosophy 2: The Physical Metaphor (Boring = Flat)

'Boring' UIs are 'flat.' Your primary tool to fix this is 'depth.' You must _simulate_ a 3D physical space with light coming from the 'top.'

- **Create Elevation:** Lighter elements feel 'closer.' Use this to show hierarchy.
  - **Heuristic:**
    ```css
    /* Base/Page */
    .bg-page {
      background-color: var(
        --md-sys-color-surface-container-lowest
      ); /* Darkest shade */
    }
    /* Cards/Mid-ground */
    .bg-card {
      background-color: var(
        --md-sys-color-surface-container-low
      ); /* Lighter shade */
    }
    /* Active/Raised Elements */
    .bg-active {
      background-color: var(
        --md-sys-color-surface-container
      ); /* Lightest shade */
    }
    ```
- **Reinforce 'Light from Above':**
  - **Gradients:** Use subtle gradients that are lighter at the top.
    - **Heuristic:**
      ```css
      .gradient-top-light {
        background: linear-gradient(
          to bottom,
          rgba(255, 255, 255, 0.05) 0%,
          transparent 100%
        );
      }
      ```
  - **Borders:** Use a `border-t-white/10` (a light top border) to _simulate_ a 'shiny' top edge.
    - **Heuristic:**
      ```css
      .border-top-shine {
        border-top: 1px solid rgba(255, 255, 255, 0.1);
      }
      ```
  - **Shadows:** Use shadows to make elements 'pop out.' Combine a soft, light glow on top with a darker shadow below.
    - **Heuristic:**
      ```css
      .elevated-shadow {
        box-shadow:
          0 1px 3px rgba(0, 0, 0, 0.1),
          0 10px 15px rgba(0, 0, 0, 0.05),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
      }
      ```
  - **Depression:** Use _inset_ shadows (dark on top, light on bottom) to make elements look 'pressed in' (e.g., for form inputs or progress bar tracks).
    - **Heuristic:**
      ```css
      .depressed-element {
        box-shadow:
          inset 0 2px 4px rgba(0, 0, 0, 0.2),
          inset 0 -1px 0 rgba(255, 255, 255, 0.05);
      }
      ```
- **Replace Borders with Depth:** Instead of `border-2`, create separation by giving an element a _slightly lighter background_ than its container.
  - **Heuristic:**
    ```css
    /* Instead of border-bottom on parent */
    .parent-container {
      background-color: var(--md-sys-color-surface-container-low);
    }
    .child-element {
      background-color: var(
        --md-sys-color-surface-container
      ); /* Slightly lighter */
    }
    ```

---

### Philosophy 3: The Perceptual Model (Color is Science, Not Just Hex)

Your goal is 'Perceptual Uniformity'—the math of the color should match how a human _sees_ it.

- **The S-Tier Tool: `OKLCH`**
  - This is the modern, perceptually uniform color model.
  - Use `oklch(L C H)` where `L` is Lightness (0-1), `C` is Chroma (saturation), `H` is Hue (0-360).
  - **Heuristic:** To create shades, _only_ adjust the `L` value. The hue will _not_ shift.
    ```css
    /* Example OKLCH usage */
    --color-primary: oklch(60% 0.15 250); /* Base blue */
    --color-primary-light: oklch(70% 0.15 250); /* Lighter shade, same hue */
    --color-primary-dark: oklch(50% 0.15 250); /* Darker shade, same hue */
    ```
- **The A-Tier Tool: `HSL`**
  - This is better than Hex/RGB for creating palettes.
  - **Heuristic:** To create shades, _only_ adjust the `L` value (Lightness).
    ```css
    /* Example HSL usage */
    --color-accent: hsl(200, 80%, 50%); /* Base cyan */
    --color-accent-light: hsl(200, 80%, 60%); /* Lighter shade, same hue */
    --color-accent-dark: hsl(200, 80%, 40%); /* Darker shade, same hue */
    ```
  - **Warning (The 'Abney Effect'):** Be aware that in HSL, adjusting lightness on some blues can make them 'turn violet.' OKLCH fixes this.
- **Context > 'Color Psychology':** Do not state 'Blue = Trust.' Color is subjective and depends on context, contrast, and existing brand associations.
- **Hardware Awareness:** Be aware of `sRGB` (standard) vs. `P3` (modern, more vibrant) color gamuts.

---

### Philosophy 4: The 80/20 Rule (Typography is 80% of Design)

Typography is the highest-leverage tool you have.

- **Heuristic: 'Emphasis by De-emphasis'**
  - To make a `<h1>` stand out (e.g., `text-white`), don't just make it bigger. Make the _secondary text_ next to it _gray_ (e.g., `text-gray-400`). This is _more_ effective.
    ```html
    <h1>Main Title</h1>
    <p class="text-gray-400">Secondary descriptive text.</p>
    ```
- **'Visual Hierarchy' > 'Document Hierarchy'**
  - The most _semantically_ important element (e.g., the `<h1>`) may not be the most _visually_ important.
  - Your job is to make the 'perfect option the most obvious solution' to a user who is _scanning_, not reading.
- **Heuristic: The 'Minimalist Type Scale'**
  - Pick one base size (e.g., `16px`).
  - Try to design _everything_ with that size, using `font-weight` (bold, medium) and `color` (white vs. gray) to create hierarchy.
  - Only go `+2px` or `-2px` from the base when absolutely necessary.
    ```css
    :root {
      --font-size-base: 1rem; /* 16px */
      --font-size-sm: 0.875rem; /* 14px */
      --font-size-lg: 1.125rem; /* 18px */
    }
    ```
- **`line-height` is 'Free' Spacing:** Use a generous line height (e.g., `leading-relaxed`) to create 'free' vertical spacing and improve readability _before_ adding `margin`.
  - **Heuristic:**
    ```css
    .text-body {
      line-height: 1.6; /* or Tailwind's leading-relaxed */
    }
    ```

---

### Philosophy 5: The Lego Model (Architecture is Design)

Your architecture _must_ be maintainable and scalable. 'Carving new blocks out of wood' every time is a failure.

- **Centralize with Variables:** _Never_ hard-code colors, fonts, or spacing.
  - Define all design decisions in _one_ place (e.g., CSS Custom Variables, Tailwind config).
  - **Example:** Define `--color-primary`, `--space-md`, `--font-body`.
    ```css
    :root {
      --color-primary: #6200ee;
      --space-md: 1rem;
      --font-body: 'Inter', sans-serif;
    }
    ```
  - This allows a human to change _one value_ and update the entire site.
- **Deconstruct & Reuse:** 'Steal' (take inspiration from) proven, tested patterns.
  - When asked for a 'page,' first deconstruct it into its _reusable components_.
  - 'How many components is this _really_?' (e.g., a 'two-column-with-image' component that can be reversed).

---

### Philosophy 6: The Storytelling Model (Clarity is King)

Your design must _communicate_ a focused message instantly.

- **'Project Naming is UI Design':** A user should know what a project is _by its name_.
  - **BAD:** 'Cool App'
  - **GOOD:** 'E-commerce Sales Dashboard for Real-Time Order Tracking'
- **Create a 'Pattern Interrupt':** Most users are scanning and _expecting_ to see the same boring things.
  - You must create a 'wow factor' to _force_ them to stop and read.
  - **BAD:** 'To-do App'
  - **GOOD:** 'AI-Powered Meal Planner That Generates Shopping Lists'
- **Design a _Focused_ Story:** Do not be a 'jack-of-all-trades.' Your design must tell a _single, focused story_ about the _one_ role it's trying to fill (e.g., 'This is a back-end developer's portfolio').
