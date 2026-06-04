---
title: 'Enterprise SAS NAS Build - Budget TrueNAS Server'
description: '10 SAS drives for 50 bucks sounded like a steal until I learned what I was getting into'
pubDate: 2025-09-28
device: nas
difficulty: medium
heroImage: /images/truenas-sas-build/01-asus-motherboard-layout.jpg
relatedNotes:
  - 'Projects/TrueNAS Build Guide'
  - 'Projects/Budget SAS Drive NAS Build Guide'
---

## What This Is

I found 10 enterprise SAS drives at a local sale for 50 bucks total. Thats 1.2TB each, 10K RPM, enterprise grade. Seemed like an absolute steal.

It wasnt. SAS drives need special controllers. Some have weird power connectors that dont fit standard SATA power. And 7 spinning 10K drives in a standard case turns into an oven real fast.

What followed was a month of sourcing parts, discovering incompatible connectors, 3D printing drive racks, and eventually running the storage outside the case with a dedicated fan blowing on it. Total cost landed around $320.

Final setup: 5.46TB usable in RAID-Z2, running TrueNAS SCALE, with two 3D printed drive racks bolted to the outside of the case.

## The Parts

| Component | What I Got | Cost |
|-----------|-----------|------|
| System | Intel i5-11400, ASRock B660M Pro RS, 32GB DDR4-3600 (2x16GB) | $190 |
| HBA Card | LSI 9207-8i in IT mode | $35 |
| SAS Cables | 2x SFF-8087 to 4x SATA with power built in | $30 |
| Storage | 10x Seagate 1.2TB 10K RPM SAS drives | $50 |
| Boot Drive | 128GB NVMe M.2 SSD | $15 |
| 3D Printed Racks | Black PETG CF | ~$3 in filament |
| **Total** | | **$320** |

Storage config: RAID-Z2 with 7 drives = 5.46TB usable. Survives any 2 drives dying at once.

## Week 1: SAS Power Connector Surprise

![SAS Drive with Incompatible Power Connector](/images/truenas-sas-build/02-sas-drive-power-incompatibility.jpg)

Some of these enterprise SAS drives have a raised section between the data and power connectors. Standard SATA power plugs physically cannot fit. You only find this out when youre holding the cable and it just wont go in.

Three out of my ten drives had this issue. Instead of returning them I went all-in on SFF-8087 cables that have power integrated. The cable carries both data and power so you never touch the drives SATA power port at all.

## Week 2: CPU Generation Matters

I originally looked at 6th-8th gen Intel systems to save money. Big mistake: those cap out at DDR4-2400. My DDR4-3600 RAM would run at two-thirds speed.

Found an i5-11400 system for $190. Supports DDR4-3200 which is close enough. The extra 30-50 bucks over older hardware was worth not wasting the RAM.

## Week 3: Motherboard Assembly

![ASRock B660M Pro RS with Intel Stock Cooler](/images/truenas-sas-build/01-asus-motherboard-layout.jpg)

Basic assembly. Intel stock cooler is fine for a 65W CPU. LSI HBA card went in the PCIe x8 slot. 2x16GB RAM.

Then I spent 2 hours troubleshooting why there was no display output. Checked cables, monitors, even pulled the HBA card thinking it was conflicting.

The RAM wasnt fully seated. I hadnt pushed hard enough. Heard the click on the second try, system posted immediately. Two hours of panic, 30 seconds to fix.

## Week 4: Thermal Reality

![System Interior with Drives and External Setup](/images/truenas-sas-build/03-system-with-external-drives.jpg)

Original plan: all drives inside the case in the 6 tool-free bays.

Reality: 7x 10K RPM drives spinning full time pushed drive temps to 50-55C within half an hour. Enterprise drives are rated to 60C but running them hot 24/7 is asking for early death.

Had to pivot to external mounting.

## The 3D Printed Solution

Printed drive racks to hold 4 drives each vertically with airflow gaps. Three prototypes:

1. Brown PLA - tested spacing and hole alignment
2. Grey-blue PLA - refined tolerances
3. Black PETG Carbon Fiber - final, heat resistant, rigid

PETG CF handles 40-45C drive temps no problem. PLA would start softening. Total filament cost under 5 bucks. Commercial racks would run 50+.

## External Cooling Setup

![External Vent Fan Cooling Solution](/images/truenas-sas-build/04-external-fan-cooling.jpg)

Two racks mounted outside the case. One 120mm PC fan behind them blowing straight through the drive stack. Blue SAS cables run from the HBA inside to the external racks.

Drive temps dropped to 38-42C under load. System pulls about 140W total with everything running. The 10K drives are louder than the fan anyway.

This turned out better than internal mounting. Easy drive access for swaps. Expandable without case limits. The workaround became the better design.

## Software

Flashed TrueNAS SCALE to a USB installer, booted from it, installed to the 128GB NVMe. Static IP at 192.168.0.120.

**Pool setup:** RAID-Z2, 7 drives, 5.46TB usable. Dual parity because I dont trust used enterprise drives. During an 8-hour rebuild you can lose another drive and not lose data. Worth the capacity hit.

**SMB share:** Dataset called Shared, accessible at `\\192.168.0.120` from anything on the network.

**Immich:** One-click install from the TrueNAS apps page. Handles PostgreSQL, Redis, containers automatically. Imported 18GB from a Google Photos takeout.

## What I Learned

**SAS power connectors are not universal.** Some have that raised center section. SFF-8087 cables with integrated power bypass it completely.

**CPU generation dictates RAM speed.** 6th-8th gen Intel = DDR4-2400 max. 11th gen = DDR4-3200. Match your parts or youre wasting money.

**Heat kills drives.** 7x 10K RPM drives in a standard case is a thermal nightmare. External mounting with dedicated cooling is the only sane option.

**IT mode HBA is mandatory.** RAID mode on the HBA fights with ZFS. IT mode is dumb passthrough. ZFS controls everything. Pre-flashed cards are worth the extra few bucks.

**Expect dead drives.** 1 out of 10 used drives was DOA. Thats normal. Still way cheaper than buying new.

**RAID-Z2 minimum.** Single parity is risky during rebuilds. Dual parity means you can lose 2 drives plus 1 more during rebuild. The 27% capacity overhead is cheap insurance.

## The Numbers

- **Local speed:** 600-700 MB/s sequential (7 drives striped)
- **Network speed:** 110 MB/s (gigabit ethernet bottleneck)
- **Power draw:** ~130W idle, ~140W active
- **Annual power cost:** ~$150 at my rate

10GbE upgrade is on the list. An Intel X540-T2 is about 50 bucks used.

## Final Word

This build taught me more about enterprise storage than any tutorial. The plan went sideways multiple times and each pivot made the final setup better.

For $320 I got 5.46TB of redundant storage running TrueNAS with Immich hosting. A Synology with similar specs would be 900+. Its not plug and play but it works and I understand every part of it.

Current status: running 24/7 for a few weeks now. Zero downtime. All drives healthy.

---

_Build date: September-October 2025_
_Status: Running 24/7, hosting Immich and SMB shares_
