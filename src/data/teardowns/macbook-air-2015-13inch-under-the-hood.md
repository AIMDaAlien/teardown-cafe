---
title: "MacBook Air 2015 13-inch Under the Hood"
description: "Exploring the internals of Apple's last pre-USB-C MacBook Air, with notes on SSD firmware upgrade challenges for running modern macOS"
pubDate: 2025-03-02
device: laptop
difficulty: easy
heroImage: /images/macbook-air-2015-13inch/01-full-internals-view.jpg
---

## Initial Inspection

Opening up the MacBook Air 2015 13-inch reveals Apple's elegant internal layout from the last generation before the major redesign. This model represents the final iteration of the classic tapered aluminum design.

## Logic Board Detail

![Close-up of logic board components](/images/macbook-air-2015-13inch/02-logic-board-closeup.jpg)

The logic board layout shows Apple's integration philosophy - everything soldered and tightly packed for maximum space efficiency in the slim chassis.

## Original OS and Firmware Considerations

![OS X El Capitan boot screen](/images/macbook-air-2015-13inch/03-os-x-el-capitan-screen.jpg)

This MacBook originally came with **OS X El Capitan 10.11** and I wanted to see if it could handle Sequoia, but came to an issue with trying that. I have to get the OEM SSD or a well-known documented SSD, update firmware by getting **macOS High Sierra 10.13+** (which includes the required EFI firmware update for third-party NVMe SSD support), and then installing whatever newer version with OpenCore.

**The firmware issue:** Third-party SSDs won't be recognized without the firmware update that ships with High Sierra 10.13 or later. The original Apple SSD must be present during the High Sierra installation to receive this firmware update.

## SSD Upgrade Considerations

![NVMe adapter installation](/images/macbook-air-2015-13inch/04-nvme-adapter-install.jpg)

### The Adapter Requirement

Apple's proprietary NVMe socket in the 2015 MacBook Air uses a custom connector that's incompatible with standard M.2 SSDs. This necessitates using an adapter to install third-party NVMe drives.

**Performance impact:**
- Adapter introduces approximately **15% speed reduction** from the drive's maximum rated speeds
- Despite this limitation, modern NVMe SSDs through adapters might still outperform the original Apple SSD
- The bottleneck comes from the adapter's PCIe lane configuration and connector translation

**Example:** A rated 3500MB/s read speed NVMe drive might achieve ~3000MB/s through the adapter - still significantly faster than the original 1200-1500MB/s Apple SSD in most configurations.

**Adapter considerations:**
- Sintech adapters are the most widely documented and compatible
- Proper seating critical to avoid recognition issues
- Some drive models more compatible than others

## Technical Specifications

**MacBook Air 13-inch, Early 2015 - Official Specifications**

### Processor
- 1.6GHz dual-core Intel Core i5 (Broadwell)
- Turbo Boost up to 2.7GHz
- 3MB shared L3 cache
- Configurable to 2.2GHz dual-core Intel Core i7

### Memory
- 4GB or 8GB of 1600MHz LPDDR3 SDRAM (onboard, not upgradeable)

### Storage
- 128GB or 256GB PCIe-based flash storage
- Configurable to 512GB

### Graphics
- Intel HD Graphics 6000 (integrated)
- Shares system memory

### Display
- 13.3-inch (diagonal) LED-backlit glossy display
- 1440 x 900 native resolution
- Millions of colors

### Connectivity
- 802.11ac Wi-Fi
- Bluetooth 4.0
- Two USB 3.0 ports
- One Thunderbolt 2 port
- SDXC card slot
- MagSafe 2 power port
- 3.5mm headphone jack

### Camera
- 720p FaceTime HD camera

### Audio
- Stereo speakers
- Dual microphones

### Physical Dimensions
- Height: 0.11-0.68 inch (0.3-1.7 cm)
- Width: 12.8 inches (32.5 cm)
- Depth: 8.94 inches (22.7 cm)
- Weight: 2.96 pounds (1.35 kg)

### Battery
- 54-watt-hour lithium-polymer battery
- Up to 12 hours wireless web browsing
- Up to 12 hours iTunes movie playback
- Up to 30 days standby time

### Operating System
- Originally shipped with OS X 10.10 Yosemite or OS X 10.11 El Capitan
- Officially supports up to macOS 12 Monterey
- Requires OpenCore Legacy Patcher for macOS 13+ (Ventura, Sonoma, Sequoia)

## Repairability Notes

- **Tool-free bottom case removal** (10 Pentalobe screws)
- **Battery replacement possible** but requires careful adhesive work
- **RAM soldered** - not user-upgradeable
- **SSD replaceable** with proprietary connector or M.2 adapter
- **Logic board repair difficult** due to integrated components

## Future Updates

*This entry will be expanded with more detailed teardown photos and firmware upgrade documentation.*

---

*Initial inspection: March 2, 2025*
*Entry status: In progress - more photos and context to be added*
