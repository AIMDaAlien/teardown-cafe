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

## What This Is

I had a perfectly fine desktop sitting on the floor in a [Jonsbo D41](https://amzn.to/4fn1kKL). It had that little attached screen which was pretty neat, though it seems like they stopped selling that version. The build worked. It was just... big. After watching enough SFF content online, I got tired of having a tower eating floor space and decided to shrink everything down.

The case itself is a [budget-friendly compact micro-ATX design by Makerunit on Printables](https://www.printables.com/model/1536973-budget-friendly-compact-matx-case-with-atx-psu). It is designed to fit a full micro-ATX board and a standard ATX power supply into way less space than you would expect. Most of the case is black PETG, and the front removable panel is silver and grey-blue PLA. Printed mostly on the P2S, though some parts came off the A1.

## The Parts List

This is what actually went inside, not some made-up specs:

- [ASRock B660M RS Pro](https://amzn.to/4fn1kKL) Intel motherboard
- [Intel i5-12600KF](https://amzn.to/4xeZiCY)
- [64GB DDR4 3600MHz](https://amzn.to/4oeJNXE)
- [Thermalright low profile cooler](https://amzn.to/3Q0oEUk)
- [be quiet! 550W ATX PSU](https://amzn.to/4uWFR04)
- [1TB ORICO PCIe Gen4 SSD](https://amzn.to/4uj7nnr) (sold out now, [this one](https://amzn.to/4vyx0Sk) is the next best thing)
- [Crucial MX500 1TB SATA SSD](https://amzn.to/4ft17pl) (way overpriced at the moment, [this alternative](https://amzn.to/3PFsPow) is better value right now)
- RTX 3060 12GB from the old build

## The Migration

### Before

![Premigration Setup](/images/3d-printed-micro-atx-case-build/01-premigration-bulky-case.jpg)

This was the starting point. The Jonsbo D41 is not a bad case at all, especially with that little screen. But it lived on the floor, and I was tired of that. The plan was simple: move everything into something that could actually sit on top of the desk without looking ridiculous.

### Motherboard Test Fit

![Motherboard and Cooler Fit](/images/3d-printed-micro-atx-case-build/02-motherboard-cooler-fit.jpg)

First panels off the printer went straight into a test fit. The B660M drops in cleanly, standoff holes line up, and the Thermalright cooler clears the top panel with just enough room. So far so good.

### Side View

![Side View Cooler Mount](/images/3d-printed-micro-atx-case-build/03-side-view-cooler-mount.jpg)

You can see the vertical layout here. The PSU exhaust fan sits at the top, pulling air up and out. CPU cooler is dead center, RAM slots are accessible, M.2 is exposed. What you cannot see yet is how the GPU and PSU are going to share this space, or where the cables are supposed to go. Still optimistic at this point.

### GPU and PSU Installed

![GPU and PSU Installed](/images/3d-printed-micro-atx-case-build/04-gpu-psu-installed.jpg)

Now it gets real. The RTX 3060 slides in horizontally, which in this vertical case means it sticks out the side. The ATX PSU mounts above it. The 24-pin and 8-pin CPU cables are already fighting for room.

The GPU power connectors live in a tight gap between the card shroud and the PSU housing. Stiff braided cables would have been a nightmare. Flat flexible cables are basically required here.

### SSD and Cable Routing

![SSD and Cable Routing](/images/3d-printed-micro-atx-case-build/05-ssd-cable-routing.jpg)

The MX500 mounts to a printed bracket on the front panel, right in front of the GPU. SATA power and data loop around the side and join the bundle of wires that are all trying to fit in a space roughly the size of a deck of cards.

Makerunit absolutely knew what they were doing with this design. Every bracket and cutout is accounted for. There is not much spare room, but there is enough, and in a case this small that is basically luxury.

### The Panels

![Wavy 3D Printed Panels](/images/3d-printed-micro-atx-case-build/06-wavy-3d-printed-panels.jpg)

Before everything gets closed up, the side panels. They have that curved wave pattern that works as both structural ribbing and airflow channels. The color split happened because I ran out of gray filament mid-print and decided to commit to it instead of starting over. The layers came out clean and the curves are smooth.

### Back View

![Final Back View](/images/3d-printed-micro-atx-case-build/07-final-back-view.jpg)

The back panel has a geometric star pattern printed in dark translucent filament. It hides cable mess while letting some LED glow through. The case sits on small printed feet just high enough for bottom intake. Power cable exits from the top rear.

### Scale Check

![Front View with RTX 4090 for Scale](/images/3d-printed-micro-atx-case-build/08-front-with-4090-scale.jpg)

This is the photo that makes the whole thing worth it. The fully assembled case with the RTX 4090 pencil case sitting on top like a hat. The 4090 pencil case is literally bigger than the entire computer. That is not camera trickery. The case is just that small.

## What Changed

The obvious one is that it went from a floor PC to a desk PC. It actually fits on top of the desk now without looking like a piece of furniture.

The downside is that the constrained space means the fans have to work harder. They are noticeably louder than before, and throttling is more likely on paper. That said, I have not actually felt any throttling happen in real use. Temperatures stay in a perfectly fine range. The vertical chimney layout does more work than you would expect.

## The Honest Verdict

**Pros:**

- Absurdly compact. Micro-ATX plus ATX PSU in a footprint smaller than most ITX builds.
- Thermally fine. The chimney airflow works better than you would think.
- Cheap. Filament cost is nothing compared to buying a case.
- Reprintable. Break a panel? Print another.

**Cons:**

- Cable management is visible. There is no behind-the-motherboard routing. Every wire is out in the open.
- No dust filtering. The open slat design means you will be cleaning it.
- GPU length limit. Anything longer than the RTX 3060 is not going to fit.
- Print time. Expect a solid chunk of hours depending on your speeds.
- Fans are louder now. Tighter space means more fan noise.

**Repairability: 8/10**

- Fully tool accessible with M3 screws
- Nothing proprietary
- Break a panel? Print another
- Deductions for tight cable access and needing to pull the PSU to reach some headers

## What I Learned

1. ATX PSUs in small spaces are totally doable if you mount them vertically.
2. PETG is the right call for structure. Rigid enough, forgiving enough.
3. Flat cables are not optional in cases this dense. They are survival equipment.
4. Most full-size desktops are like 70% empty air.
5. The 3D printing community on Printables is doing genuinely impressive work. Makerunit handled tolerances better than some commercial cases I have used.

## Next Steps

- [x] Print case panels
- [x] Transplant all components
- [x] Verify it does not overheat
- [x] Take a photo with a 4090 on top for scale
- [ ] Maybe design a custom fan duct for directed CPU airflow
- [ ] Try a dual-tone PETG and TPU flexible panel variant at some point

## Final Word

This build proves that "desktop PC" does not have to mean "takes up the entire desk." You can fit a genuinely capable system into a volume smaller than a shoebox if you are willing to deal with visible cables and a bit more fan noise. The tradeoffs are worth it for the footprint you get back.

**Build Difficulty:** Medium (planning matters more than skill)
**Cost:** Great (filament is cheap, your time is not)
**Thermal Performance:** Fine for what it is
**Smugness Factor:** Off the charts when you put a 4090 on top

**Final Verdict:** 5/5. A good reminder that the 3D printing community can build things that rival commercial stuff when given enough CAD patience and PETG spools.
