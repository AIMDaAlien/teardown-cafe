---
title: "HP EliteBook 840 G7 Teardown → Frankenstein AIO"
description: "Converting a broken-screen HP EliteBook 840 G7 into a makeshift all-in-one computer - upgrading RAM/SSD, extracting WiFi antenna, and mounting the motherboard behind a monitor"
pubDate: 2023-05-18
device: laptop
difficulty: medium
heroImage: /images/hp-elitebook-g7-840/04-laptop-disassembled.jpg
relatedNotes:
  - "Hardware/Laptop Repair Techniques"
  - "Projects/Teardown Cafe Workspace Evolution"
---

## Project Overview

An HP EliteBook 840 G7 with a cracked screen (only 30% viewable) got converted into a frankenstein all-in-one computer. Instead of scrapping it or paying for an expensive screen replacement, I tore it down, upgraded the internals, and eventually mounted the entire motherboard assembly to the back of an external monitor.

**Device Specifications:**
- **Model**: HP EliteBook 840 G7
- **Processor**: Intel Core i5 (10th Gen)
- **RAM**: Upgraded during teardown
- **Storage**: Upgraded to 512GB SSD
- **Original Issue**: Cracked screen (30% viewable)
- **Year**: ~2020-2021 model

**Context:** Did this teardown in Bangladesh during May 2023. I was staying there for a few weeks and didn't have access to my usual workspace or tools. The laptop screen had cracked badly enough that only about 30% was usable, so I connected it to an external 75Hz monitor and decided to upgrade the internals while I had it open.

Eventually, I went further - removed the motherboard with CPU, RAM, and cooling still attached, superglued it to the back of the monitor, and left the speakers hanging at the bottom. Basically created a janky all-in-one desktop from laptop parts.

## Workspace Evolution

### Initial Setup Challenge

![Keyboards Comparison](/images/hp-elitebook-g7-840/01-keyboards-comparison.jpg)

Limited desk space meant creative workspace solutions:

- **Full-size mechanical keyboard** (left) - Daily driver
- **HP EliteBook keyboard** (right) - The patient with cracked screen
- **Rapoo wireless mouse** (bottom) - Blue/teal aesthetic
- **Dark desk surface** - Good contrast for component visibility

The overlapping keyboards show the space constraints I was dealing with. This cramped setup eventually motivated building a dedicated teardown station.

### Dual Monitor Configuration

![Workspace with Dual Monitors](/images/hp-elitebook-g7-840/02-workspace-dual-monitor.jpg)

Full workspace during the project:

**Display Setup:**
- **Primary monitor**: 27" external display (desktop riser)
- **Secondary display**: Large TV mounted above
- **Laptop**: EliteBook with cracked screen (eventually just used external monitors)

**Organization:**
- **Upper shelf**: Notebooks, tissues, desk stuff
- **Drawer unit**: Screws and small parts
- **Lower drawer**: Documents and tools
- **Desk surface**: Working area

The dual-monitor setup was useful for repair guides and documentation, though I probably didn't need all three screens.

### Refined Workspace Angle

![Workspace Setup - Alternative View](/images/hp-elitebook-g7-840/03-workspace-setup.jpg)

Different angle showing workspace details:

**Lighting:** Green-tinted ambient lighting (terrible for precision work - probably from the AC unit)

**Tools visible:**
- Notebook for handwritten notes
- Yellow folder with reference materials
- Screwdriver set
- AC unit on right (Bangladesh gets hot)

## Teardown & Upgrade Process

### Disassembly

![Laptop Disassembled - Component Overview](/images/hp-elitebook-g7-840/04-laptop-disassembled.jpg)

**Tools used:**
- iFixit precision screwdriver set (yellow/black visible here)
- Plastic opening tools
- Magnetic parts tray (upper left)

**Components visible:**
- **Bottom case panel** (right) - Screw locations marked
- **Internal flex cables** (upper left) - Laid out to avoid tangling
- **Motherboard** (center) - With cooling solution
- **Battery** (right side) - Standard Li-ion
- **WiFi antenna** - Copper-looking wire extracted because WiFi felt slow

**Organization:**
- Screws organized by removal order
- Cables laid flat
- Case panel showing screw boss locations

### Upgrades Made

During disassembly, I upgraded:

**RAM:** Added more memory (exact amount I don't recall, but maxed out what it could take)

**Storage:** Upgraded to 512GB SSD (from whatever was in there originally)

**WiFi antenna:** Pulled out the WiFi antenna (the copper-looking wire visible in photos) because wireless felt slow. Having it external seemed to help signal strength.

## The Frankenstein Conversion

### Initial External Monitor Setup

After the teardown and upgrades, I initially just used the laptop with a 75Hz external monitor since the internal screen was unusable. The laptop sat open with the cracked screen ignored, connected via HDMI to the external display.

### Final All-in-One Configuration

Eventually I took it further:
1. Removed the motherboard with CPU, RAM, cooling, and storage still attached
2. Superglued the motherboard assembly to the back of the 75Hz monitor
3. Left the speakers hanging at the bottom of the monitor
4. Connected power and display directly

This created a makeshift all-in-one desktop computer. Not pretty, but functional - and kept a laptop with a broken screen from becoming e-waste.

**Why this worked:**
- Motherboard still had all functional components
- External monitor was already being used
- Laptop speakers could hang freely (not great acoustics, but functional)
- Power delivery still worked fine
- WiFi antenna external gave better signal anyway

## Technical Specifications

### HP EliteBook 840 G7 Details

**Processor:**
- Intel Core i5-10210U (Comet Lake, 10th Gen)
- 4 cores / 8 threads
- 1.6GHz base, 4.2GHz turbo
- 15W TDP (configurable to 25W)

**Memory (Upgraded):**
- DDR4-3200 SO-DIMM
- Dual-channel
- Upgraded to maximum supported capacity

**Storage (Upgraded):**
- 512GB NVMe SSD (upgraded from original)
- M.2 2280 slot
- PCIe 3.0 x4 interface

**Display (Original - Broken):**
- 14" diagonal
- 1920x1080 (Full HD)
- Cracked (only ~30% viewable)
- Replaced with external 75Hz monitor

**Connectivity:**
- Intel Wi-Fi 6 AX201 (antenna extracted externally)
- Bluetooth 5.0
- 2x USB-C with Thunderbolt 3
- 2x USB-A 3.1 Gen 1
- HDMI 2.0 (used for external monitor)

**Physical:**
- Dimensions: 12.7" x 8.5" x 0.7" (323mm x 217mm x 17.9mm)
- Weight: ~3.0 lbs (1.36 kg) - irrelevant after supergluing to monitor
- Chassis: Aluminum with magnesium reinforcement

## Workspace Design Insights

This project captured workspace evolution during travel:

### Challenges

❌ **Lighting**: Green ambient lighting inadequate
❌ **Space constraints**: Limited work surface
❌ **Tool organization**: Ad-hoc storage
❌ **Limited resources**: Basic toolkit only

### What I Learned

✅ **Improvisation works**: Limited tools forced creative problem-solving
✅ **External repair viable**: Broken screen laptop can become desktop
✅ **Upgrade while open**: Already disassembled, might as well max out specs
✅ **Travel teardowns possible**: Quality work in non-ideal conditions

**Timeline:**
- **May 2023**: This project (Bangladesh)
- **August 2023**: Refined workspace post-travel
- **October 2025**: Current dedicated teardown station

## Lessons Learned

### Technical

📚 **Screen damage isn't fatal**: Cracked laptop screens can be bypassed with external monitors
📚 **Upgrade while open**: Disassembly is a good time for RAM/SSD upgrades
📚 **WiFi antenna placement**: External antenna can improve signal
📚 **Frankenstein builds work**: Unconventional mounting solutions are viable
📚 **Speaker flexibility**: Laptop speakers can hang freely if secured

### Practical

📚 **External monitors**: 75Hz+ makes a noticeable difference for desktop use
📚 **Superglue holds**: Motherboard mounted to monitor back stayed secure
📚 **E-waste reduction**: Broken-screen laptops have salvageable internals
📚 **Travel constraints**: Limited resources force better problem-solving

### Business Laptop Specific

📚 **Modular design**: EliteBook's single-panel access made upgrades easy
📚 **Standard components**: SO-DIMM RAM and M.2 SSD easily upgraded
📚 **Good build quality**: Motherboard handled unconventional mounting

## Repairability Assessment: 7/10

**Pros:**
✅ **Single-panel access**: Easy internal access
✅ **Standard screws**: Phillips and Torx
✅ **Modular components**: RAM, storage, Wi-Fi easily replaced
✅ **Upgrade friendly**: Maxed out RAM and storage during teardown

**Cons:**
❌ **Screen replacement expensive**: Why I went the external monitor route
❌ **Soldered CPU/GPU**: Not upgradeable
❌ **Integrated battery**: Requires internal access

**Overall**: Excellent for unconventional projects. The modular design made this frankenstein conversion possible.

## Related Documentation

📝 **[Teardown Workspace Evolution](https://aimdaalien.github.io/knowledge-garden-vault/?note=Projects/Teardown%20Cafe%20Workspace%20Evolution)** - Workspace evolution 2023-2025

📝 **[Laptop Repair Techniques](https://aimdaalien.github.io/knowledge-garden-vault/?note=Hardware/Laptop%20Repair%20Techniques)** - General troubleshooting

## Outcome

**Problem solved:** Cracked screen bypassed with external monitor, then full frankenstein AIO conversion

**Upgrades completed:**
- RAM maxed out
- 512GB SSD installed
- WiFi antenna externalized (copper wire visible in photos)

**Final configuration:**
- Motherboard superglued to back of 75Hz monitor
- Speakers hanging at bottom
- External WiFi antenna for better signal
- Functional desktop from broken laptop

**What I learned:**
- Screen damage doesn't mean laptop is dead
- External monitors make broken screens irrelevant
- Frankenstein builds are viable with proper planning
- Travel constraints force creative solutions
- E-waste can be prevented with unconventional thinking

## Conclusion

This HP EliteBook 840 G7 went from "cracked screen paperweight" to functional frankenstein all-in-one desktop. The project proved that laptop hardware can be repurposed in unconventional ways - supergluing a motherboard to a monitor isn't elegant, but it works.

**Key takeaways:**

💡 **Broken screens aren't fatal** - External monitors make damaged displays irrelevant
💡 **Upgrade while disassembled** - Already open, might as well max out specs
💡 **Unconventional mounting works** - Superglue holds motherboards to monitors
💡 **Travel innovation** - Limited resources force creative problem-solving
💡 **E-waste reduction** - "Broken" laptops have perfectly good internals

**Bangladesh context:** Doing this project while traveling with limited tools showed that you don't need a perfect setup for creative hardware projects. The constraints actually helped - I probably wouldn't have tried the frankenstein AIO conversion if I'd had access to easy screen replacement services.

The hanging speakers at the bottom of the monitor aren't pretty, but they work. The external WiFi antenna (that copper wire visible in the teardown photos) actually improved signal. The 75Hz monitor made it feel more responsive than the original 60Hz laptop screen anyway.

**Final assessment:**
- **Project difficulty**: Medium (basic disassembly, creative mounting)
- **Cost savings**: Avoided expensive screen replacement
- **Functionality**: Full desktop functionality from broken laptop
- **Aesthetics**: 2/10 (it's janky but who cares)
- **Practicality**: 9/10 (works great, nothing wasted)

**Historical note:** This project (Bangladesh, May 2023) proved that hardware constraints inspire creative solutions. The frankenstein all-in-one still works as of this documentation.

---

*Project completed: May 2023 (Dhaka, Bangladesh)*
*Current status: Functional frankenstein AIO*
*Documentation: October 2025*
