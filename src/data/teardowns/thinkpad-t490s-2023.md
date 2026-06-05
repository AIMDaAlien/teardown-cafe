---
title: 'ThinkPad T490s - Under the Hood'
description: 'Opened a ThinkPad T490s just to see what was inside. No repair needed, just curiosity.'
pubDate: 2023-08-30
device: laptop
difficulty: easy
heroImage: /images/thinkpad-t490s-2023/01-internals-overview.jpg
tags:
  - laptop
  - thinkpad
  - teardown
---

## What This Is

Opened a ThinkPad T490s to see the internals. No repair needed. Just wanted to check the component layout and build quality.

![ThinkPad T490s Internals](/images/thinkpad-t490s-2023/01-internals-overview.jpg)

## Whats Inside

**Left side:**

- Battery: Lenovo Li-ion pack, 11.4V, internal non-removable design
- Fan assembly: single fan with dual heatpipes, one to the CPU area

**Center and right:**

- Motherboard with CPU under the heatsink
- RAM is soldered to the board. Not upgradeable.
- M.2 slot visible but the SSD was removed in this photo
- Wireless card in an M.2 slot

**Ports along the edge:** USB-C, USB-A, HDMI, audio jack, and whatever else the T490s config includes.

## Build Quality

Clean cable routing in channels. Single bottom panel for access. WiFi card and SSD are modular. Mostly Phillips screws. Magnesium-aluminum chassis.

## Upgradeability

**Not upgradeable:**
- RAM (soldered)
- CPU (soldered)
- Battery (requires full disassembly)

**Replaceable:**
- M.2 NVMe SSD
- M.2 WiFi card
- Cooling fan
- CMOS battery

## Context

The T490s is Lenovos 14-inch business ultrabook from 2019-2020. This generation got thinner with more soldered components. Older ThinkPads like the T420 era were modular and upgradeable. The T490s trades that for reduced thickness and weight.

Typical specs: Intel Core i5 or i7 (8th or 10th gen), 8GB or 16GB soldered RAM, M.2 NVMe storage, 14-inch IPS display, about 2.8 pounds, MIL-STD-810G certified.

## Why I Documented This

Wanted to see what a modern ThinkPad ultrabook looks like inside. The soldered RAM was expected for this model but I wanted visual confirmation of the layout. Photo reference is useful for future work on similar machines.

---

_Documented: August 2023_
_Purpose: Curiosity, component layout reference_
