---
title: "HP EliteBook 840 G7 Teardown"
description: "Tearing down a broken HP EliteBook 840 G7 (i5, 16GB RAM) in a makeshift workspace during a Bangladesh trip - documenting what I found and what went wrong"
pubDate: 2023-05-18
device: laptop
difficulty: medium
heroImage: /images/hp-elitebook-g7-840/04-laptop-disassembled.jpg
relatedNotes:
  - "Hardware/Laptop Repair Techniques"
  - "Projects/Teardown Cafe Workspace Evolution"
---

## Project Overview

This documents tearing down an HP EliteBook 840 G7 that died on me. The goal was figuring out what killed it, seeing if anything was salvageable, and documenting the internals since I had it open anyway.

**Device Specifications:**
- **Model**: HP EliteBook 840 G7
- **Processor**: Intel Core i5 (10th Gen)
- **RAM**: 16GB DDR4
- **Status**: Dead (wouldn't POST)
- **Year**: ~2020-2021 model

**Context:** I did this teardown in Bangladesh during May 2023. I was staying there for a few weeks and didn't have access to my usual workspace or tools, which made this... interesting. The constraints actually ended up being useful - I learned what's actually essential for teardown work versus what's just nice to have. Working with limited desk space, questionable lighting, and a basic toolkit forced me to be more methodical than I might've been otherwise. This makeshift setup is basically what eventually became the dedicated teardown.cafe workspace, just minus the organization and proper lighting.

The Bangladesh context matters because it shows you don't need a perfect setup to document teardowns properly - you just need to be systematic about it. Though I definitely wouldn't recommend the green-tinted lighting I was dealing with.

## Workspace Evolution

### Initial Setup Challenge

![Keyboards Comparison](/images/hp-elitebook-g7-840/01-keyboards-comparison.jpg)

I had basically zero desk space to work with, which meant getting creative with layout. This photo shows the keyboard situation:

- **Full-size mechanical keyboard** (left) - My daily driver
- **HP EliteBook keyboard** (right) - The patient
- **Rapoo wireless mouse** (bottom) - Blue/teal because apparently I have a color scheme
- **Dark desk surface** - At least the contrast was good for seeing components

The overlapping keyboards here highlight the space problem pretty well. I eventually realized this cramped setup wasn't sustainable if I wanted to do more teardowns, which is part of why I built out a dedicated station later.

### Dual Monitor Configuration

![Workspace with Dual Monitors](/images/hp-elitebook-g7-840/02-workspace-dual-monitor.jpg)

My full workspace during this phase:

**Display Setup:**
- **Primary monitor**: 27" external display on a desktop riser
- **Secondary display**: Large TV mounted above (overkill, but it was already there)
- **Laptop**: The EliteBook itself, positioned as a third screen before teardown

**Organization:**
- **Upper shelf**: Notebooks, tissues, random desk stuff
- **Drawer unit**: Attempted organization for screws and small parts
- **Lower drawer**: Documents and tools (loosely defined as "organization")
- **Desk surface**: Working area that never stayed clear

**Cable management**: Visible power strip on the right because I gave up on hiding cables

The dual-monitor setup let me have repair guides up on the TV, component datasheets on the primary monitor, and camera feed on the laptop screen. Honestly probably didn't need all three screens for a basic teardown, but it felt professional at the time.

### Refined Workspace Angle

![Workspace Setup - Alternative View](/images/hp-elitebook-g7-840/03-workspace-setup.jpg)

Different angle showing more workspace details:

**Lighting:** Green-tinted ambient lighting (absolutely terrible for component work - note to self: fix this for future teardowns). I'm pretty sure this was the AC unit's fault, but I never figured out why the lighting had that weird tint.

**Component Layout:**
- **Keyboard**: Full-size in comfortable typing position for documentation
- **Mouse**: Right-handed placement
- **Work surface**: Dark wood grain - non-conductive and provided decent contrast

**Documentation tools:**
- Notebook in the lower shelf for handwritten notes (because typing during disassembly is awkward)
- Yellow folder with reference materials
- Screwdriver set partially visible

**Climate control**: AC unit visible on the right. Bangladesh gets hot, and I wasn't about to do precision work while sweating over a laptop.

## Teardown Process

### Disassembly

![Laptop Disassembled - Component Overview](/images/hp-elitebook-g7-840/04-laptop-disassembled.jpg)

**Tools I actually used:**
- iFixit precision screwdriver set (the yellow/black one visible here)
- Plastic opening tools (essential - don't try this with metal)
- Magnetic parts tray for small components (upper left corner)

**Components visible:**
- **Bottom case panel** (right side) - Note the screw locations marked with rubber feet
- **Internal flex cables** (scattered upper left) - I laid these out to avoid tangling
- **Motherboard** (center) - Exposed with cooling solution visible
- **Battery** (right side of case) - Standard laptop Li-ion

**Organization approach:**
- Brown desk surface provided good contrast for silver/black components
- Screws organized by removal order (critical for reassembly - learned this the hard way on previous projects)
- Cables laid flat to prevent tangling
- Case panel positioned to show screw boss locations for reference

**Initial observation:** No obvious physical damage to external components, which suggested the failure was internal. Likely motherboard issue or power delivery problem based on the symptoms (no POST, no display activity, no fan spin).

The disassembly confirmed the laptop used standard HP EliteBook construction - single bottom panel removal provides access to all major components. RAM, storage, Wi-Fi card, and battery are all easily accessible for replacement or testing. The modular design is one of the reasons business-class laptops like the EliteBook series are worth considering for repairability.

## Failure Analysis

### What Was Wrong

Based on the symptoms (no POST, no display, no fan):
- Wouldn't power on at all
- No fan spin when plugged in
- No display backlight
- Battery charging LED would light up (so power delivery to battery worked)

### Likely Culprits

**Primary suspects:**

1. **Motherboard Power Delivery Circuit**
   - VRM failure is common in 10th gen Intel laptops
   - Capacitor degradation after 2-3 years of heavy use is typical
   - If the VRMs can't deliver stable power to CPU/GPU, system won't POST

2. **Thermal System Failure → Cascade Failure**
   - Fan bearing fails → inadequate cooling
   - Thermal paste degrades → CPU thermal throttles
   - Repeated thermal stress → eventual component failure
   - Dust accumulation makes this worse

3. **BIOS Corruption**
   - Less likely given the symptoms
   - BIOS corruption usually shows different behavior
   - Could be resolved with chip reflash, but that requires specialized equipment I didn't have

**Secondary possibilities:**
- RAM failure (unlikely - dual-channel provides redundancy)
- Storage failure (wouldn't prevent POST)
- Display connector (wouldn't explain lack of fan spin)

I'm betting on VRM failure as the root cause, but without proper diagnostic equipment (multimeter at minimum, ideally an oscilloscope), I couldn't verify this. The laptop was old enough that board-level repair wasn't economically viable anyway.

### Component Salvage Assessment

**What I could reuse:**
✅ **RAM modules**: 16GB DDR4-3200 SO-DIMM (tested in another system - worked fine)
✅ **NVMe SSD**: If it was present (I don't remember if this had one or if it was already removed)
✅ **Wi-Fi 6 card**: Intel AX201 - compatible with other laptops
✅ **Battery**: If cycle count < 500 (didn't check, probably should have)
⚠️ **Cooling system**: Fan testable, heatsink reusable after cleaning
❌ **Motherboard**: Dead - only useful as parts donor for other repairs

## Technical Specifications

### HP EliteBook 840 G7 Details

**Processor:**
- Intel Core i5-10210U (Comet Lake, 10th Gen)
- 4 cores / 8 threads
- 1.6GHz base, 4.2GHz turbo
- 15W TDP (configurable to 25W)

**Memory:**
- 16GB DDR4-3200 SO-DIMM
- Dual-channel
- Upgradeable to 64GB (BIOS permitting)

**Storage:**
- M.2 2280 NVMe slot
- PCIe 3.0 x4 interface
- Supports up to 2TB

**Display:**
- 14" diagonal
- 1920x1080 (Full HD)
- IPS panel, anti-glare coating
- 400 nits brightness (claimed)

**Connectivity:**
- Intel Wi-Fi 6 AX201 (802.11ax)
- Bluetooth 5.0
- Gigabit Ethernet
- 2x USB-C with Thunderbolt 3
- 2x USB-A 3.1 Gen 1
- HDMI 2.0
- Audio combo jack
- Nano SIM slot (on WWAN models)

**Security:**
- TPM 2.0
- Fingerprint reader
- IR camera for Windows Hello
- HP Sure Start (BIOS self-healing - didn't help in this case)
- HP Sure View privacy screen (optional)

**Physical:**
- Dimensions: 12.7" x 8.5" x 0.7" (323mm x 217mm x 17.9mm)
- Weight: ~3.0 lbs (1.36 kg)
- Chassis: Aluminum with magnesium reinforcement
- MIL-STD-810H certified (drop/shock/vibration resistance)

## Workspace Design Insights

This teardown captured a transitional phase in my workspace evolution:

### Problems I Identified

❌ **Lighting**: Green ambient lighting was terrible for precision work
❌ **Space constraints**: Limited horizontal surface area
❌ **Tool organization**: Ad-hoc storage was inefficient
❌ **Documentation setup**: Camera placement wasn't optimized
❌ **Cable management**: Tangled power cables everywhere

### What I Changed Later

✅ **Dedicated workspace**: Built out larger organized area
✅ **Proper lighting**: Added white LED task lighting
✅ **Tool organization**: Magnetic trays and proper organizers
✅ **Camera rig**: Overhead mount for documentation
✅ **ESD protection**: Anti-static mat and grounding strap

**Timeline:**
- **May 2023**: This makeshift setup (Bangladesh)
- **August 2023**: Refined workspace post-travel
- **October 2025**: Current dedicated teardown station

## Lessons Learned

### Technical Takeaways

📚 **Test components first**: Should've tested RAM and storage before full disassembly - would've saved time
📚 **Check thermal paste early**: Often reveals overheating issues before you dig deeper
📚 **Keep BIOS recovery ready**: USB recovery can fix firmware issues (though not in this case)
📚 **Document cable routing**: Take photos before removing cables - saves headaches during reassembly
📚 **Organize screws systematically**: Magnetic tray with labeled sections - non-negotiable

### Workspace Insights

📚 **Lighting matters**: Proper illumination prevents mistakes and speeds up work significantly
📚 **Surface selection**: Non-conductive, high-contrast work surface is essential
📚 **Tool accessibility**: Keep frequently used tools within arm's reach - standing up to grab a screwdriver breaks flow
📚 **Separate camera**: Don't rely on phone for documentation - dedicated camera or overhead mount
📚 **ESD protection**: Anti-static precautions prevent accidental component damage

### Travel Teardown Specific

📚 **Minimal toolkit works**: Can do quality teardowns with basic screwdriver set and plastic tools
📚 **Constraints breed creativity**: Limited resources force better problem-solving technique
📚 **Documentation over perfection**: Good photos and notes matter more than perfect environment
📚 **Improvisation skills**: Working in different countries teaches tool sourcing adaptability
📚 **Methodology over equipment**: Quality work possible in non-ideal conditions with proper approach

### Business Laptop Specific

📚 **Enterprise security**: BIOS passwords and encryption common - track credentials
📚 **Check warranty first**: Enterprise coverage is often extensive - verify before voiding
📚 **Parts availability**: HP business parts well-stocked, but verify exact model compatibility
📚 **Service manuals exist**: HP publishes detailed service docs for EliteBook series

## Repairability Assessment: 7/10

**Pros:**
✅ **Single-panel access**: Bottom cover removal exposes serviceable parts
✅ **Standard screws**: Mostly Phillips and common Torx sizes
✅ **Modular components**: RAM, storage, Wi-Fi easily replaceable
✅ **Good documentation**: HP service manuals available
✅ **Parts availability**: Common business laptop, parts accessible

**Cons:**
❌ **Soldered CPU/GPU**: Not upgradeable
❌ **Integrated battery**: Requires internal access to remove
❌ **Some proprietary connectors**: HP-specific flex cables
❌ **Thermal system access**: Full disassembly needed for proper thermal paste replacement

**Overall**: Above-average repairability for a business ultrabook. Common failures (RAM, storage, thermal) are user-serviceable with basic tools.

## Related Documentation

This teardown connects to several topics:

📝 **[Teardown Workspace Evolution](https://aimdaalien.github.io/knowledge-garden-vault/?note=Projects/Teardown%20Cafe%20Workspace%20Evolution)** - How the workspace evolved from 2023-2025

📝 **[Laptop Repair Techniques](https://aimdaalien.github.io/knowledge-garden-vault/?note=Hardware/Laptop%20Repair%20Techniques)** - General troubleshooting methodology

## Outcome

**Diagnosis:** Likely motherboard power delivery failure (VRM circuit)

**Repair viability:** Not economical - board-level component replacement costs more than a replacement laptop

**Salvaged components:**
- 16GB DDR4 RAM (moved to another laptop)
- Intel Wi-Fi 6 card (stored for future use)
- NVMe SSD (if present - pending verification)
- Battery (if cycle count acceptable)
- Cooling assembly (cleaned and stored)

**What I learned:**
- HP EliteBook modular design and component accessibility
- Common failure modes in 10th gen Intel ultrabooks
- Workspace optimization needs
- Documentation workflow improvements
- How to do teardowns with limited resources

## Conclusion

This HP EliteBook 840 G7 teardown served two purposes: trying to diagnose a dead laptop (unsuccessful) and documenting workspace evolution (successful). The laptop was beyond economical repair, but I salvaged some useful components and learned what workspace features actually matter.

**Key takeaways:**

💡 **Business laptops** like the EliteBook 840 G7 have better repairability than consumer ultrabooks
💡 **Workspace matters** - Moving from this setup to a dedicated station improved efficiency dramatically
💡 **Document everything** - Even failed repairs provide value when documented properly
💡 **Reuse components** - Quality parts (RAM, Wi-Fi, storage) from dead systems can live on
💡 **Methodology over equipment** - Good teardown work is possible anywhere with systematic approach

**Bangladesh context:** Doing this teardown while traveling highlighted how methodology matters more than equipment. The constraints of a temporary setup with limited tools forced efficiency improvements that carried over to my permanent workspace design. This proved that good teardown documentation - systematic disassembly, component photos, detailed notes - transcends workspace limitations.

That said, I definitely wouldn't choose to work with green-tinted lighting again if I had the option.

**Final assessment:**
- **Teardown difficulty**: Medium (2-3 hours for complete disassembly)
- **Educational value**: High (good example of modern business laptop architecture)
- **Parts salvage**: Partial (~50% of components recovered)
- **Workspace evolution impact**: Significant (directly informed dedicated station design)
- **Travel documentation**: Successful proof that location-independent teardown work is viable

**Historical note:** This teardown (Bangladesh, May 2023) represents an early phase in the teardown.cafe project. The workspace limitations visible here motivated creating a dedicated, properly-equipped station. Working in suboptimal conditions taught me what's actually essential versus what's just nice to have.

---

*Teardown completed: May 2023 (Dhaka, Bangladesh)*
*Documentation: October 2025*
*Status: Historical reference / Workspace evolution documentation*
