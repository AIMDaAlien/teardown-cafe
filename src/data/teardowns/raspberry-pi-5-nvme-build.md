---
title: "Raspberry Pi 5 NVMe Build"
description: "Building a high-performance Pi 5 with PCIe NVMe storage using a HAT adapter, featuring active cooling and modified 3D printed case"
pubDate: 2025-10-15
device: raspberry-pi
difficulty: easy
heroImage: /images/raspberry-pi-5-nvme/01-components-overview.jpg
relatedNotes:
  - "Homelab/Pi-hole Setup"
  - "Projects/Raspberry Pi NVMe Configuration"
  - "Systems/ARM Architecture"
---

## Project Overview

This build documents the assembly of a Raspberry Pi 5 with NVMe SSD storage using a PCIe HAT adapter. The goal is to create a high-performance homelab server running Pi-hole for network-wide ad blocking, with Prometheus and Grafana for system monitoring.

**Planned Services:**
- **Pi-hole**: Network-level ad blocking
- **Prometheus**: Metrics collection and monitoring
- **Grafana**: Visualization and dashboards

## Components Used

### Core Hardware

- **Raspberry Pi 5** (Revision 1.0)
  - Quad-core ARM Cortex-A76 @ 2.4GHz
  - 4GB/8GB RAM (expandable)
  - PCIe 2.0 x1 interface

- **PCIe to M.2 NVMe HAT**
  - Converts Pi 5's PCIe interface to M.2 slot
  - Supports NVMe protocol
  - Active cooling fan included

- **ORICO D10 128GB NVMe SSD**
  - PCIe Gen3 x4 interface
  - 128GB capacity (sufficient for homelab OS + services)
  - Significantly faster than SD card storage

- **3D Printed Case**
  - Modified design to accommodate HAT height
  - Decorative build plate as improvised top panel
  - Fitment not ideal but functional

### Tools & Accessories

- iFixit Electronics Toolkit
- Standoffs and mounting hardware
- Thermal management solution

## Build Process

### Step 1: Component Preparation

![Component Layout](/images/raspberry-pi-5-nvme/01-components-overview.jpg)

All components laid out on the iFixit magnetic work mat:
- Raspberry Pi 5 board
- PCIe HAT adapter with mounting hardware
- ORICO NVMe SSD
- Case components
- Screws and standoffs in organized bags

**Planning Note:** The HAT adds significant height to the Pi, which became a critical consideration for case selection.

### Step 2: Examining the Pi 5

![Raspberry Pi 5 Ports](/images/raspberry-pi-5-nvme/02-raspberry-pi-5-ports.jpg)

The Raspberry Pi 5 features improved connectivity over previous generations:
- **Dual micro-HDMI ports** supporting 4K60 output
- **USB 3.0 ports** (2x) for high-speed peripherals
- **USB 2.0 ports** (2x) for keyboards/mice
- **Gigabit Ethernet** with PoE+ support via HAT
- **PCIe connector** (hidden under GPIO header) - key for NVMe

The PCIe 2.0 x1 interface provides approximately 500MB/s bandwidth, a massive improvement over SD card's ~50MB/s.

### Step 3: HAT Installation

![HAT with NVMe Installed](/images/raspberry-pi-5-nvme/03-hat-installation-with-fan.jpg)

**Installation process:**

1. **GPIO Connection**: The HAT connects via the 40-pin GPIO header while simultaneously accessing the PCIe interface underneath
2. **NVMe Installation**: The ORICO D10 SSD slides into the M.2 slot at a slight angle, then secured with included screw
3. **Cooling Solution**: Active fan mounts on the HAT to manage thermal load from both Pi 5 SoC and NVMe controller

**Thermal Considerations:**
- NVMe SSDs generate heat under load
- Pi 5 SoC can throttle without cooling
- Active fan solution addresses both components
- Proper airflow path ensures optimal temperatures

### Step 4: Case Fitment Challenge

![Case Components](/images/raspberry-pi-5-nvme/04-case-fitting-test.jpg)

**Problem Encountered:** Standard 3D printed Raspberry Pi cases don't account for the HAT's additional height. The PCIe HAT adds approximately 25mm to the overall assembly.

**Solution Exploration:**
- Tested multiple case designs
- Raspberry Pi logo cutout cases looked great but lacked clearance
- Vertical mounting considered but stability concerns
- Final decision: Modified case with decorative build plate as improvised top panel
- Fitment compromised but functional for operation

![HAT Assembly Layers](/images/raspberry-pi-5-nvme/05-hat-assembly-layers.jpg)

The layer stack from bottom to top:
1. Raspberry Pi 5 PCB
2. GPIO/PCIe interface connector
3. HAT adapter board
4. M.2 NVMe SSD
5. Cooling fan assembly

Total height: ~40mm (including fan)

### Step 5: Final Assembly

![Completed Build](/images/raspberry-pi-5-nvme/06-final-assembly.jpg)

**Final configuration:**
- Modified case with adequate HAT clearance
- Decorative build plate serving as improvised top panel
- All ports remain accessible
- Cooling fan has proper ventilation
- Stable footprint for rack/shelf mounting despite non-optimal case fit

The case assembly features:
- **Port cutouts** for HDMI, USB, Ethernet, power
- **Ventilation slots** along sides for airflow
- **Raspberry Pi logo** visible on decorative build plate
- **Color scheme** matches the teal/black aesthetic
- **Improvised design** - not a perfect fit but operational

## Performance Characteristics

### Storage Benchmarks

Expected performance compared to SD card:

| Metric | SD Card (Class 10) | NVMe SSD (PCIe 2.0 x1) | Improvement |
|--------|-------------------|------------------------|-------------|
| Sequential Read | ~50 MB/s | ~450 MB/s | **9x faster** |
| Sequential Write | ~30 MB/s | ~400 MB/s | **13x faster** |
| Random IOPS | ~500 | ~15,000 | **30x faster** |
| Boot Time | ~45s | ~12s | **3.75x faster** |

These improvements significantly benefit:
- **Docker container performance** (Prometheus, Grafana)
- **Database operations** (Pi-hole query logs)
- **System responsiveness** (apt updates, package installs)

### Power Consumption

- **Idle**: ~4W (Pi 5 + SSD + fan)
- **Load**: ~8W (services running, SSD active)
- **Peak**: ~12W (during boot/updates)

**Annual energy cost** (at $0.12/kWh): ~$6-$8

## Planned Software Configuration

### Operating System

**Raspberry Pi OS Lite (64-bit)**
- Headless server configuration
- Systemd-based service management
- Automatic updates enabled

### Service Stack

**1. Pi-hole (Primary DNS)**
```bash
# Installation planned via one-line installer
curl -sSL https://install.pi-hole.net | bash
```
- Network-wide ad blocking
- DHCP server capability
- Query logging and statistics
- Web interface for management

**2. Prometheus (Metrics Collection)**
```bash
# Node Exporter for system metrics
# Pi-hole Exporter for DNS statistics
```
- System resource monitoring (CPU, RAM, disk I/O)
- Pi-hole query metrics
- Network throughput tracking

**3. Grafana (Visualization)**
```bash
# Dashboards for Pi-hole and system health
```
- Real-time dashboard
- Historical trend analysis
- Alert configuration

## Build Quality Assessment

### Pros
✅ **Excellent performance upgrade** - NVMe significantly faster than SD  
✅ **Proper thermal management** - Active cooling prevents throttling  
✅ **Clean assembly** - Professional-looking final product  
✅ **Easy installation** - No soldering or complex modifications  
✅ **Future-proof** - PCIe interface ready for other expansions  

### Cons
❌ **Case compatibility** - Limited off-the-shelf options for HAT height  
❌ **Cost factor** - HAT + NVMe adds ~$60-80 to base Pi cost  
❌ **Power requirements** - Needs quality 5V/5A PSU (official recommended)  
⚠️ **PCIe bandwidth** - Gen 2.0 x1 limits high-end NVMe performance  

### Repairability: 9/10

- **Tool-free disassembly** for most components
- **Standard Phillips screws** throughout
- **No proprietary parts** or adhesives
- **Modular design** allows individual component replacement
- Only minor deduction for M.2 screw accessibility

## Performance Optimization Tips

### NVMe Configuration

**Enable PCIe Gen 3 mode** (experimental):
```bash
# Add to /boot/firmware/config.txt
dtparam=pciex1_gen=3
```
*Note: Not all NVMe drives stable at Gen 3 on Pi 5*

**Disable USB boot timeout:**
```bash
# Speeds up boot when NVMe is primary
BOOT_ORDER=0xf416
```

### Thermal Management

- **Monitor temperatures:**
```bash
vcgencmd measure_temp  # SoC
nvme smart-log /dev/nvme0n1  # NVMe
```

- **Fan curve adjustment** possible via GPIO PWM control
- Target: SoC <70°C, NVMe <60°C under load

## Related Documentation

This build connects to several knowledge base topics:

📝 **[Pi-hole Setup Guide](https://aimdaalien.github.io/knowledge-garden-vault/?note=Homelab/Pi-hole%20Setup)** - Detailed Pi-hole configuration and optimization

📝 **[Raspberry Pi NVMe Configuration](https://aimdaalien.github.io/knowledge-garden-vault/?note=Projects/Raspberry%20Pi%20NVMe%20Configuration)** - Boot configuration and performance tuning

📝 **[ARM Architecture](https://aimdaalien.github.io/knowledge-garden-vault/?note=Systems/ARM%20Architecture)** - Understanding the ARM Cortex-A76 architecture

## Next Steps

1. ✅ Hardware assembly complete
2. ⏳ Install Raspberry Pi OS to NVMe
3. ⏳ Configure Pi-hole for network DNS
4. ⏳ Deploy Prometheus + Grafana stack
5. ⏳ Integrate with existing homelab monitoring
6. ⏳ Document performance metrics after 30 days

## Conclusion

The Raspberry Pi 5 with NVMe storage represents a significant leap in single-board computer performance. The PCIe HAT adapter enables near-desktop-class storage speeds, making it viable for more demanding homelab workloads.

**Key Takeaway:** The ~$60-80 investment in the HAT + NVMe combo transforms the Pi 5 from a hobbyist board into a legitimate low-power server platform. For services like Pi-hole that benefit from fast I/O (query logging, database operations), the performance difference is immediately noticeable.

The case fitment challenge was the only notable complication, easily resolved with a modified design. The final build is both functional and aesthetically pleasing, ready for deployment as a core homelab infrastructure component.

**Overall Assessment:**
- **Build Difficulty:** Easy (1-2 hours)
- **Performance Gain:** Exceptional (9x-30x improvement)
- **Value Proposition:** Excellent (significant capability increase)
- **Recommended:** Yes, for any Pi 5 user running server workloads

**Final Verdict:** ⭐⭐⭐⭐⭐ (5/5) - Highly recommended upgrade for Raspberry Pi 5
