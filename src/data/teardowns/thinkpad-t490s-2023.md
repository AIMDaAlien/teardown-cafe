---
title: "ThinkPad T490s - Under the Hood"
description: "Quick look inside a Lenovo ThinkPad T490s out of curiosity - documenting what the internals look like"
pubDate: 2023-08-30
device: laptop
difficulty: easy
heroImage: /images/thinkpad-t490s-2023/01-internals-overview.jpg
relatedNotes:
  - "Hardware/Laptop Repair Techniques"
---

## Quick Look Inside

Opened up a ThinkPad T490s just to see what the internals looked like. No particular repair needed - just curiosity about the component layout and build quality.

**Device:**
- **Model**: Lenovo ThinkPad T490s
- **Year**: ~2019-2020
- **Date**: August 2023

![ThinkPad T490s Internals](/images/thinkpad-t490s-2023/01-internals-overview.jpg)

## What's Visible

**Left side (from this angle):**
- **Battery**: Lenovo Li-ion pack taking up significant space
  - 11.4V nominal voltage marked on label
  - Internal, non-removable design
  - Battery warning labels visible
- **Fan assembly**: Single cooling fan with dual heatpipes
  - One pipe goes to CPU area
  - Thermal solution adequate for 15W ultrabook processor

**Center/Right:**
- **Motherboard**: Main logic board with components
  - CPU under heatsink (center area)
  - RAM is **soldered** to motherboard - not upgradeable
  - M.2 slot visible but **SSD removed** in this photo
- **Wireless card**: M.2 slot with Wi-Fi module installed

**Ports visible:**
- USB-C ports along edge
- USB-A ports
- HDMI connector
- Audio jack
- Various other connectivity (exact layout depends on T490s configuration)

**Build observations:**
- Clean cable routing along channels
- Single bottom panel removal for access
- Modular construction where possible (Wi-Fi card, SSD)
- Mostly Phillips screws
- Magnesium-aluminum chassis construction

**What's NOT upgradeable on T490s:**
- RAM (soldered to motherboard)
- CPU (soldered)
- Battery (requires full disassembly to replace)

**What IS replaceable:**
- M.2 NVMe SSD
- M.2 Wi-Fi card
- Cooling fan
- CMOS battery

## ThinkPad T490s Context

The T490s is Lenovo's 14" ultrabook from the business ThinkPad line. This generation marked Lenovo's shift to thinner designs with more soldered components. Unlike older ThinkPads (T420/T430 era), the T490s sacrifices upgradeability for reduced thickness and weight.

**Typical specs:**
- Intel Core i5/i7 (8th or 10th Gen)
- 8GB or 16GB RAM (soldered)
- M.2 NVMe storage
- 14" IPS display
- ~2.8 lbs weight
- MIL-STD-810G certified

## Why I Documented This

Just wanted to see what's inside a modern ThinkPad ultrabook. The soldered RAM was expected based on the model, but wanted visual confirmation of the layout. Having the photo as reference is useful for future work on similar models.

---

*Documented: August 2023*
*Purpose: Curiosity / Component layout reference*
