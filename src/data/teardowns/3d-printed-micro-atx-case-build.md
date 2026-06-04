---
title: '3D Printed Micro-ATX Case Build'
description: 'Shrinking a full desktop setup into a custom 3D printed micro-ATX case that fits an RTX GPU, ATX PSU, and somehow still leaves the RTX 4090 looking oversized'
pubDate: 2026-01-11
device: desktop
difficulty: medium
heroImage: /images/3d-printed-micro-atx-case-build/08-front-with-4090-scale.jpg
tags:
  - 3d-printing
  - pc-building
  - sff
  - micro-atx
  - custom-case
  - rtx
---

## Project Overview

This build answers a question nobody asked but everyone secretly wonders: *how small can you make a micro-ATX desktop before it becomes physically uncomfortable?* The answer, it turns out, is "small enough that an RTX 4090 Founders Edition is larger than the entire computer."

The case is a [budget-friendly compact micro-ATX design by NixieShift on Printables](https://www.printables.com/model/1536973-budget-friendly-compact-matx-case-with-atx-psu), designed specifically to cram a full micro-ATX motherboard and standard ATX power supply into the tightest possible footprint. I printed the panels in a two-tone gray and light blue scheme, and the creator was kind enough to [leave a review on my make](https://www.printables.com/make/3225141) — which is either validation or a polite warning to others, depending on your interpretation.

## Components Used

### Core Hardware

- **ASRock B550M Pro4** micro-ATX motherboard
- **AMD Ryzen** CPU (cooled by a Thermalright tower cooler)
- **MSI GeForce RTX** dual-fan graphics card
- **be quiet! ATX Power Supply** — yes, a full ATX unit, shoehorned vertically
- **Crucial 2.5-inch SATA SSD** — mounted on a custom 3D printed bracket
- **M.2 NVMe SSD** — because every millimetre counts

### The Case

- **3D Printed Micro-ATX Case** (PETG, ~0.3mm layer height)
  - Two-tone panel scheme: gray + light blue
  - Curved wavy slat design on side panels for airflow
  - Geometric star-pattern back panel
  - Panel-mount construction with M3 hardware

### Tools Used

- Bambu Lab 3D printer (the same one that later earned its own teardown here)
- iFixit toolkit for assembly
- Patience, and a lot of it

## Build Process

### Step 0: The Before Times

![Premigration Setup](/images/3d-printed-micro-atx-case-build/01-premigration-bulky-case.jpg)

This was the starting point: a perfectly respectable mid-tower case doing mid-tower things. ASRock board, MSI RTX card, Thermalright cooler, an M.2 drive, a SATA SSD flopping around in the basement, and enough empty volume to store a week's worth of groceries. It worked. It was fine. It was also *massive*, and after spending enough time around Small Form Factor builds online, "fine" started to feel like "wasted desk space."

The migration plan was simple: transplant every component into a case that occupies roughly one-third the footprint. What could go wrong?

### Step 1: Motherboard Test Fit

![Motherboard and Cooler Fit](/images/3d-printed-micro-atx-case-build/02-motherboard-cooler-fit.jpg)

The first panel set came off the printer and immediately went into a test fit. The ASRock B550M drops into the frame with surprising precision — the standoff holes line up, the I/O shield cutout is correctly sized, and the Thermalright cooler clears the top panel by what feels like a calculated millimetre. The RAM slots are accessible. The M.2 slot is exposed. So far, the case design is living up to its promise.

**Observation:** The print quality matters here. Any warping in the base plate would throw off standoff alignment and stress the motherboard. PETG at moderate speeds proved to be the right call.

### Step 2: Clearance Check from the Side

![Side View Cooler Mount](/images/3d-printed-micro-atx-case-build/03-side-view-cooler-mount.jpg)

Rotating the frame shows the vertical layout more clearly. The be quiet! exhaust fan mounts to a dedicated bracket at the top of the case, creating a direct chimney airflow path. The CPU cooler sits dead centre, the RAM is tucked alongside it, and the M.2 drive is visible just above the chipset heatsink.

What is not yet visible: the GPU, the PSU, or any sense of how the cables will route. The optimism is still intact at this stage.

### Step 3: Adding the Heavy Hitters

![GPU and PSU Installed](/images/3d-printed-micro-atx-case-build/04-gpu-psu-installed.jpg)

Now the real engineering shows up. The MSI GeForce RTX card slides into the PCIe slot horizontally, which in this vertical case means it protrudes from the side like a drawer. The ATX PSU mounts above it, oriented so its fan aligns with the top exhaust. The 24-pin motherboard cable and 8-pin CPU cable are already fighting for space.

**Key challenge:** The GPU power connectors now live in a narrow canyon between the card's shroud and the PSU housing. Cable selection matters — stiff braided cables would not have fit. Flexible, flat cables are mandatory.

### Step 4: Storage and Cable Tetris

![SSD and Cable Routing](/images/3d-printed-micro-atx-case-build/05-ssd-cable-routing.jpg)

The Crucial 2.5-inch SSD mounts to a printed bracket on the front panel, directly in front of the GPU. SATA power and data cables loop around the side, joining the growing bundle of wires being politely asked to occupy negative space. The PSU's cables — motherboard, CPU, GPU, SATA — all converge in a zone roughly the size of a deck of cards.

This is the point where you realise the case designer absolutely knew what they were doing. Every bracket, every cutout, every millimetre of clearance has been accounted for. It is not *generous* clearance, but it is *sufficient* clearance, which in SFF is the same thing as luxury.

### Step 5: The Aesthetic Reveal

![Wavy 3D Printed Panels](/images/3d-printed-micro-atx-case-build/06-wavy-3d-printed-panels.jpg)

Before the panels go on, a moment to appreciate the design. The side panels use a curved wave pattern that serves double duty: structural ribbing for rigidity, and directional airflow channels. The two-tone split — half gray, half light blue — was a filament-change experiment that turned into a deliberate aesthetic choice. The layers are clean, the curves are smooth, and the whole thing looks more like a piece of desktop sculpture than a spool of melted plastic.

### Step 6: The Back Panel

![Final Back View](/images/3d-printed-micro-atx-case-build/07-final-back-view.jpg)

The rear of the completed build reveals the geometric back panel — a tessellated star pattern printed in translucent dark filament that lets LED glow through while hiding cable chaos. The case sits on small printed feet, elevated just enough for bottom intake. The power cable exits cleanly from the top rear.

On the shelf below: parts organisers, because a build this compact requires a well-stocked spare screw collection for the inevitable "what if I want to upgrade the RAM?" moments.

### Step 7: Scale Check

![Front View with RTX 4090 for Scale](/images/3d-printed-micro-atx-case-build/08-front-with-4090-scale.jpg)

Here is the money shot. The fully assembled micro-ATX case, panels on, running, alive — with an NVIDIA RTX 4090 Founders Edition resting on top of it like a hat. The 4090 is physically larger in every dimension than the entire computer beneath it. This is not a trick of perspective. The case is genuinely that small, and the 4090 is genuinely that comically oversized in comparison.

**Components inside the case:** motherboard, CPU, cooler, RAM, GPU, PSU, two SSDs, cables, hopes, dreams.
**Components on top of the case:** one GPU that would not fit inside in a million years.

## Thermal & Performance Notes

### Airflow Design

The case relies on a chimney effect:

1. **Bottom intake**: Through the ventilated base and gaps around the GPU
2. **CPU cooler**: Pulls air across the heatsink and pushes it upward
3. **Top exhaust**: The be quiet! fan evacuates hot air directly upward

### Temperatures (Approximate, Ambient ~22°C)

| Component   | Idle    | Gaming Load |
| ----------- | ------- | ----------- |
| CPU         | ~40°C   | ~75°C       |
| GPU         | ~35°C   | ~78°C       |
| PSU         | ~38°C   | ~55°C       |

These are perfectly acceptable for a case with no dedicated intake fans. The vertical layout and natural convection do more work than expected.

### Noise Profile

- **Idle**: Nearly silent. The be quiet! fan spins down, and the GPU's zero-RPM mode keeps things whisper-quiet.
- **Load**: Audible but not intrusive. The top exhaust fan carries most of the thermal workload.

## Build Quality Assessment

### Pros

✅ **Absurdly compact** — micro-ATX + ATX PSU in a footprint smaller than most ITX builds  
✅ **Surprisingly thermally competent** — chimney airflow works better than sceptics predict  
✅ **Customisable** — print it in any colour, any filament, with any panel pattern variants  
✅ **Inexpensive** — filament cost is a fraction of even budget aluminium cases  
✅ **Community-validated** — the original designer reviewed this exact build  

### Cons

❌ **Cable management is an art form** — there is no behind-the-motherboard routing; every wire is visible  
❌ **No dust filtering** — open slat design means regular cleaning is necessary  
❌ **GPU length limited** — anything longer than a dual-slot, dual-fan card will not fit  
❌ **3D printing time** — expect 20-30 hours of print time depending on settings  

### Repairability: 8/10

- **Fully tool-accessible** — M3 screws and panel clips
- **Standard parts** — nothing proprietary
- **Re-printable** — break a panel? Print another.
- Deductions for: tight cable access and the need to remove the PSU to reach some motherboard headers

## What I Learned

1. **ATX PSUs in small spaces are possible** — vertical mounting is underrated.
2. **PETG is the right material** — rigid enough for structure, forgiving enough for tolerance stacking.
3. **Flat cables are not optional** — they are survival equipment in cases this dense.
4. **Scale is relative** — your "full-size desktop" is probably 70% empty air.
5. **Designers on Printables are doing incredible work** — NixieShift's case design handles tolerances better than some commercial products.

## Next Steps

- [x] Print case panels
- [x] Transplant all components
- [x] Verify thermal stability under load
- [x] Take a photo with an RTX 4090 on top for internet points
- [ ] Design a custom fan duct for directed CPU airflow
- [ ] Experiment with a dual-tone PETG+TPU flexible panel variant

## Conclusion

This build proves that "desktop PC" does not have to mean "desk-dominating monolith." By leveraging a well-designed 3D printable case, it is possible to fit a genuinely capable gaming and productivity system into a volume smaller than a shoebox. The trade-offs — cable visibility, GPU length limits, print time — are entirely reasonable for the footprint gained.

**Key Takeaway:** The future of PC cases is not exclusively machined aluminium and tempered glass. Sometimes it is melted plastic, carefully layered, with just enough clearance to keep your GPU from suffocating.

**Overall Assessment:**

- **Build Difficulty:** Medium (planning matters more than skill)
- **Cost:** Exceptional (filament is cheap; your time is not)
- **Thermal Performance:** Surprisingly good for passive chimney flow
- **Smugness Factor:** Off the charts when you place a 4090 on top

**Final Verdict:** ⭐⭐⭐⭐⭐ (5/5) — A testament to what the 3D printing community can achieve when given enough CAD patience and PETG spools.
