---
title: 'Server Drive Rebuild - When SAS Drives Die'
description: 'The HP SAS drives died faster than expected. Fried SATA connectors, molex adapters, and a switch to Unraid.'
pubDate: 2026-05-05
device: nas
difficulty: medium
heroImage: /images/server-drive-rebuild/02-new-hard-drives.jpg
tags:
  - nas
  - homelab
  - unraid
  - hard-drives
  - sas
---

## What This Is

Remember those 8 HP SAS drives I bought for $50? They started dying. Faster than I expected. I had the 4TB HGST as "backup" but that was just raw storage, not an actual redundant backup. When the SAS array started throwing errors I realized I should have set up real backups from day one.

This is the story of replacing dead drives, discovering fried SATA power connectors, and eventually switching to Unraid because TrueNAS was eating too much of my time.

## The Death Spiral

The HP 2.5-inch 10K SAS drives were enterprise pulls with thousands of hours already on them. I knew they werent going to last forever but I hoped for a couple years. Instead I started seeing SMART errors and failed sectors within months.

One drive went completely. Then another started throwing warnings. The array was still functional but I was one more failure away from losing data. The 4TB HGST I had sitting in there wasnt configured as backup. It was just extra storage. Rookie mistake.

## The Damage

![Messy drive situation before rebuild](/images/server-drive-rebuild/01-hard-drives-messy.jpg)

When I pulled the old drives I found something worse than dead platters. The SATA power connectors on some of the cables were physically fried. Scorched plastic, melted contacts. The HP drives had drawn more power than expected or the connectors were loose and arcing. Either way, several SATA power plugs from the PSU were unusable.

This meant I couldnt just plug new drives in. I needed a workaround.

## New Drives

![New 3.5-inch drives installed](/images/server-drive-rebuild/02-new-hard-drives.jpg)

Replaced the dead SAS array with:

- **2x Seagate ST2000NM0045** - 2TB, 7200RPM each
- **1x WD DC HC555** - 16TB, model WUH722016CL5204, 7200RPM
- **Kept the 4TB HGST** - still alive somehow

These are all 3.5-inch drives. Bigger physically, more reliable, and they run cooler than the tiny 2.5-inch SAS drives crammed together. Total usable storage went up significantly.

## The Molex Problem

With several SATA power connectors fried, I had to use a molex-to-SATA power adapter to get the new drives running. Molex is old school but it works. The adapter splits one molex plug into multiple SATA power connectors. Not elegant but it solved the immediate problem.

I also 3D printed a rack to hold the new 3.5-inch drives. The old 2.5-inch cage wasnt going to work. The new rack fits in the Jonsbo case but its tight. Getting the glass side panel on requires some cable management gymnastics.

## Switching to Unraid

TrueNAS had become a time sink. Every update seemed to break something. Debugging meant hours in forums and logs. I asked my AI agents (I call them my butlers) for suggestions on easier-to-diagnose alternatives and they pointed me at Unraid.

Unraid is $50 a year for up to 6 storage devices. The community is bigger, support is better, and apps are containerized through Docker which means way more available software. But the UI is genuinely offputting. For $50 a year I expected a polished interface. Instead it looks like a web app from 2010. Bland, clunky, functional but not pretty.

The Docker complexity gives me anxiety. Im not a backend engineer. Containers, volumes, networks, compose files - its a lot. I manage it by SSHing in and having my CLI AI agents walk me through troubleshooting. That works but its not exactly user-friendly.

Home Assistant migrated over fine. Still controlling the hydroponic towers. The garden doesnt care what OS the server runs.

## Results

The new drives run noticeably cooler. Fewer errors. No more fan-spin-up panic when the old SAS drives started struggling. The 16TB WD is overkill for what I need right now but it means I wont have to think about storage for a while.

Downside is the case is even more cramped with 3.5-inch drives. The glass panel barely fits. Cable management is basically impossible at this point. I just shove wires where theyll stay and hope for the best.

## What I Learned

**Backups arent optional.** I thought having a separate 4TB drive meant I was covered. It doesnt. You need actual backup strategy, not just extra storage sitting in the same case.

**Used SAS drives have a shelf life.** Enterprise pulls are cheap because theyre already worn out. The $50 I saved cost me in data anxiety and replacement drives.

**SATA power connectors can fry.** I didnt know that was a thing until I saw the melted plastic. Check your connectors regularly if youre running used drives.

**Unraid is easier but uglier.** TrueNAS looks better and has ZFS. Unraid is simpler to troubleshoot but the UI is rough. Pick your poison.

**Docker is powerful but intimidating.** Having AI agents that can SSH in and help debug containers is basically mandatory for me. Without them Id be lost.

## Final Word

This rebuild wasnt planned. It was forced by dying drives and the realization that my backup strategy was imaginary. The new setup is more reliable, has more storage, and runs cooler. But the case is a mess inside and Im still learning Unraid.

If youre building a NAS with used drives, budget for replacements. And actually set up backups. Not " Ill copy stuff over later." Real backups. Learn from my mistake.

---

_Rebuild: May 2026_
_Status: Running Unraid, Home Assistant migrated, new drives healthy_
