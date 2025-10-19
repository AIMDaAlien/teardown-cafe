---
title: "Enterprise SAS NAS Build - Budget TrueNAS Server"
description: "Building a 5.46TB enterprise NAS using 10 SAS drives with custom 3D printed external cooling racks for under $320"
pubDate: 2025-09-28
device: nas
difficulty: medium
heroImage: /images/truenas-sas-build/01-asus-motherboard-layout.jpg
relatedNotes:
  - "Projects/TrueNAS Build Guide"
  - "Projects/Budget SAS Drive NAS Build Guide"
---

## Project Overview

I scored 10 enterprise SAS hard drives for $50 at a local sale - seemed like a steal until reality hit: SAS drives need specialized controllers, some have non-standard power connectors, and fitting 7+ spinning 10K RPM drives in a standard case becomes a thermal nightmare. What followed was a month of sourcing parts, discovering incompatible connectors, 3D printing custom drive racks, and ultimately running the storage externally with dedicated cooling.

**Final Setup:** 5.46TB RAID-Z2 storage server running TrueNAS SCALE, with two 3D printed drive racks mounted outside the case with a PC fan providing active cooling. Total cost: ~$320.

## Hardware Breakdown

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 12px; padding: 24px; margin: 24px 0; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);">

| Component | Specs | Cost |
|:----------|:------|-----:|
| **System** | Intel i5-11400, ASRock B660M Pro RS, 32GB DDR4-3600 (2x16GB) | **$190** |
| **HBA Card** | LSI 9207-8i (IT mode, P20 firmware) | **$35** |
| **SAS Cables** | 2x SFF-8087 to 4x SATA with integrated power | **$30** |
| **Storage** | 10x Seagate 1.2TB 10K RPM SAS drives | **$50** |
| **Boot Drive** | 128GB NVMe M.2 SSD | **$15** |
| **3D Printed Racks** | Black PETG CF (prototyped in PLA) | **~$0*** |
| | | |
| **Total** | | **$320** |

<div style="margin-top: 16px; padding: 12px; background: rgba(147, 51, 234, 0.1); border-left: 3px solid #9333ea; border-radius: 4px; font-size: 0.9em;">

*Filament cost negligible (~$3-5 material)

</div>

<div style="margin-top: 16px; padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 8px; border: 1px solid rgba(16, 185, 129, 0.3);">

**Storage Config:** RAID-Z2 (7 drives) = 5.46TB usable, survives any 2 drive failures

</div>

</div>

## The Build Journey

### Week 1: The SAS Connector Surprise

![SAS Drive with Incompatible Power Connector](/images/truenas-sas-build/02-sas-drive-power-incompatibility.jpg)

**The Problem:** Some enterprise SAS drives have a center section between the power and data connectors that blocks standard SATA power plugs. This isn't documented anywhere obvious - you only discover it when the cable physically won't fit.

**What I'm holding in this photo:**
- Standard SATA power connector (red cable)
- SAS data connector positioned at an angle
- The middle raised section preventing SATA power insertion

**The Solution:** SFF-8087 to SATA cables with integrated power bypass this entirely. The cable provides both data (via SAS) and power (via standard SATA) without needing the drive's SATA power port.

This discovery happened with 3 out of 10 drives. Rather than return them, I went all-in on the SFF-8087 cable solution.

### Week 2: CPU Generation Matters

Originally targeted 6th-8th gen Intel to save money. Critical mistake: those CPUs max out at DDR4-2400, meaning my DDR4-3600 RAM would only run at 67% capacity.

**The Fix:** Found i5-11400 system for $190 (supports DDR4-3200 = 89% utilization). The extra $30-50 over older systems was worth proper hardware matching.

### Week 3: Motherboard Assembly

![ASRock B660M Pro RS with Intel Stock Cooler](/images/truenas-sas-build/01-asus-motherboard-layout.jpg)

**Component Layout:**
- **ASUS motherboard** with Intel stock cooler (adequate for 65W TDP)
- **PCIe slots:** LSI HBA card installed in x8 slot
- **RAM configuration:** 2x 16GB DDR4 sticks (32GB total, not visible under cooler)
- **Case fans:** 120mm rear exhaust, front intake planned

**The RAM Drama:** First boot showed zero display output despite fans spinning. Spent 2 hours troubleshooting cables, monitors, even pulled the HBA card. 

**Actual problem:** RAM not fully seated. Removed all sticks, pushed harder until **loud click**, system posted immediately. Time wasted: 2 hours. Time to fix: 30 seconds.

### Week 4: The Thermal Reality Check

![System Interior with Drives and External Setup](/images/truenas-sas-build/03-system-with-external-drives.jpg)

**Initial Plan:** Mount all drives internally using the 6 tool-free bays (yellow thumbscrews visible).

**Reality:** 
- 7x 10K RPM drives spinning = significant heat generation
- Case airflow inadequate (140W continuous power draw)
- Drive temps climbed to 50-55°C within 30 minutes
- Enterprise drives rated to 60°C, but longevity suffers

**The Pivot:** External mounting with dedicated cooling became necessary.

### The 3D Printing Solution

**Iteration Process:**
1. **Prototype 1:** Brown PLA - tested spacing and mounting hole alignment
2. **Prototype 2:** Grey-blue PLA - refined tolerances, tested screw fit
3. **Final Version:** Black PETG Carbon Fiber - heat resistance, rigidity

**Rack Design:**
- Holds 4 drives vertically with airflow gaps
- Mounting points align with drive screw holes
- Open-air design maximizes cooling
- Stackable for future expansion

**Material Choice:** PETG CF chosen for:
- Higher heat tolerance than PLA (80°C vs 60°C)
- Carbon fiber adds rigidity
- Black finish looks professional
- Doesn't warp near 40-45°C drive temps

### Final Cooling Setup

![External Vent Fan Cooling Solution](/images/truenas-sas-build/04-external-fan-cooling.jpg)

**Configuration:**
- 2x 3D printed racks mounted outside case
- Single 120mm PC fan positioned behind drives
- Fan blows directly through drive stack
- Blue SAS cables route from HBA to external racks

**Thermal Results:**
- Drive temps: 38-42°C under load (down from 50-55°C)
- System power: ~140W total (drives + fan + system)
- Noise level: Acceptable (10K RPM drives louder than fan)

**Why This Works:**
- Separates drive heat from system heat
- Dedicated airflow for storage
- Easy drive access for swapping
- Expandable to 8+ drives without case limitations

## Software Setup

### TrueNAS SCALE Installation

1. Flashed USB installer, booted from it
2. Installed to entire 128GB NVMe (TrueNAS takes full control)
3. Console network config: Static IP 192.168.0.120
4. Web GUI access: http://192.168.0.120

### ZFS Pool Creation

**Storage → Create Pool:**
- Name: `Storage_Pool`
- Layout: **RAID-Z2** (dual parity)
- Width: 7 drives (5 data + 2 parity)
- Result: 5.46TB usable from 7.63TB raw

**RAID-Z2 Choice:** Survives any 2 simultaneous drive failures. During an 8-hour rebuild, the array can lose another drive without data loss. Worth the 27% capacity overhead.

### SMB Sharing

Created dataset `Shared`, enabled SMB, accessible from:
- Windows: `\\192.168.0.120`
- Mac: `smb://192.168.0.120`
- Linux/Android: Same SMB path

### Immich (Self-Hosted Photos)

**Apps → Discover Apps → Immich → Install**

One-click deployment. TrueNAS handles PostgreSQL, Redis, Docker containers automatically. Access at `http://192.168.0.120:2283`. Imported 18GB from Google Photos Takeout.

## Key Lessons Learned

### Hardware Realities

**1. Not All SAS Drives Have Standard Power Connectors**
- Some enterprise drives have raised center sections
- Blocks standard SATA power insertion
- SFF-8087 cables with integrated power solve this universally

**2. CPU Generation Dictates RAM Utilization**
- 6th-8th gen Intel: DDR4-2400 max (67% of DDR4-3600)
- 11th gen Intel: DDR4-3200 max (89% of DDR4-3600)
- $30-50 price difference justified by proper matching

**3. Thermal Management is Critical**
- 7x 10K RPM drives = ~100W heat generation
- Standard case airflow insufficient
- External mounting with dedicated cooling necessary

**4. 3D Printing Enables Custom Solutions**
- Prototyping in cheap PLA validates design
- Production in PETG CF for durability
- Total cost: <$5 in filament vs $50+ commercial racks

### Software Insights

**5. IT Mode HBA is Non-Negotiable**
- RAID mode on HBA fights with ZFS
- IT mode = dumb passthrough, ZFS controls everything
- Pre-flashed cards worth extra $5

**6. RAID-Z2 Minimum for Peace of Mind**
- Single parity (RAID-Z1) risky during rebuilds
- Dual parity survives 2 failures + 1 during rebuild
- 27% capacity overhead = cheap insurance

**7. Expect 10% DOA Rate on Used Drives**
- 1 dead drive out of 10 = industry standard
- Still 70% cheaper than buying new
- Plan for failures, have spares

## Performance & Maintenance

**Storage Speed:**
- Local: 600-700 MB/s sequential (7 drives aggregated)
- Network: 110 MB/s (limited by gigabit ethernet)
- 10GbE upgrade planned (~$50 Intel X540-T2)

**Power Consumption:**
- Idle: 130W (system + 7 drives + fan)
- Active: 140W (file transfers)
- Annual cost: ~$147/year @ $0.12/kWh

**Automated Maintenance:**
- Monthly ZFS scrubs (data integrity verification)
- Weekly SMART tests (drive health monitoring)
- Hourly snapshots (7-day retention)

## Build Assessment

### What Worked ✅

- SFF-8087 cables solved power connector issues universally
- 3D printed racks provided perfect custom solution
- External mounting eliminated thermal constraints
- RAID-Z2 provides excellent reliability
- Total cost 64% below equivalent Synology ($320 vs $900)

### What Could Be Better ⚠️

- External drives not aesthetically ideal (but functional)
- Network limited to 110 MB/s (10GbE upgrade needed)
- 140W power draw higher than hoped
- Initial internal mounting failed (lesson learned)

### Repairability: 9/10

- Tool-free drive swapping (external racks)
- Standard screws throughout
- Modular HBA card (PCIe slot)
- 3D printed parts easily reprinted if damaged

## Conclusion

Building a TrueNAS server from scratch taught me more about enterprise storage than any tutorial could. The key wasn't following a perfect plan - it was adapting when reality didn't match expectations.

**Major Pivots:**
1. SAS power connectors don't fit → SFF-8087 integrated cables
2. Internal thermal issues → External 3D printed racks
3. Cheap Molex adapters → Quality integrated cables
4. Older CPU + fast RAM → Matched generation components

**Final Numbers:**
- Cost: $320 (vs $900 Synology equivalent)
- Time: 1 month sourcing + 6 hours build/troubleshoot
- Capacity: 5.46TB RAID-Z2 (survives 2 failures)
- Status: 3 weeks running, zero downtime, all drives healthy

**Would I Recommend This?**

**Yes, if you:**
- Enjoy troubleshooting and iterating solutions
- Have access to 3D printer (or can prototype externally)
- Value learning over plug-and-play convenience
- Are comfortable with CLI and enterprise hardware

**No, if you:**
- Need guaranteed plug-and-play reliability
- Want official warranty support
- Prefer "it just works" over DIY customization
- Time is more valuable than money

**Personal Verdict:** The external drive rack solution isn't what I originally planned, but it's objectively better - easier access for maintenance, superior cooling, expandable to 10+ drives without case constraints. Sometimes the "workaround" becomes the optimal design.

**Current Status:** Running 24/7, hosting Immich (18GB photos), serving 5 devices via SMB, zero issues. The 3D printed racks and external cooling transformed a thermal problem into a maintenance advantage.

⭐⭐⭐⭐ (4/5) - Highly recommended for DIY enthusiasts willing to iterate solutions
