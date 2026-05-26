# Inside the 800VDC Revolution – Part 1
## Four-Phase 800VDC Transition, Power Rack Economics, SST, Equipment Content/MW Build, Supplier Implications
**Nicolas Bontigui, Jeremie Eliahou Ontiveros, Konrad Wang, and 3 others | May 26, 2026**

We’d like to thank DG Matrix, Novos Power, and Aran Industries for their contributions and insights during the preparation of this deep dive.

### Introduction: Welcome to the Power Chain Roller Coaster
Across every major industry conference in the first half of 2026, our research team kept walking past the same scene: a booth ten or fifteen people deep, leaning in to catch every word from another datacenter equipment messiah preaching the gospel of 800VDC. The pitch was the same every time. 800VDC is about to change the electrical infrastructure of the datacenter.

Every architectural shift looked excessive at first. Operators spent decades keeping water and leaks out of the data hall, then GPU thermal density made running coolant right up against the precious silicon unavoidable. Each shift happened anyway, because physics and the economics of compute do not negotiate. 800VDC is next, and the logic is the same. Tokens per watt are what matters.

As GPU clusters become increasingly dense, with Kyber Ultra approaching 660kW per rack, the physics start to break down. Resistive losses scale with current squared, and at these power levels copper mass and thermal envelope exceed what fits inside a rack. Moving to 800VDC eliminates conversion stages, reduces resistive losses, and cuts facility-level power consumption by ~5%. At 1GW of IT load, that is over 50MW of continuous savings, tens of millions in annual electricity costs, or new compute capacity unlocked. For all the inference-king proponents out there, 800VDC is a transition forced by physics and motivated by system economics.

We have been tracking this transition through our InferenceX and Industrials Models, which provide a bottom-up view of where efficiency gains materialize and which equipment categories absorb the disruption. The Industrials Model includes a dedicated 800VDC module, building up from individual accelerator architectures to a top-down view of 800VDC penetration, MW adoption, and market sizing for equipment like the power sidecar and Solid-State Transformers (SSTs).

This deep dive traces the transition phase by phase: from the sidecar retrofit, through faciliy-level DC distribution, to the SST endgame. For each phase, we analyze the BoM and map the changes in equipment content/MW, what survives, what gets redesigned, and what gets eliminated.

The 800VDC revolution is set to dramatically change the revenue trajectory of certain suppliers. We’ve been tracking winners and losers for over a year in Industrials Model, which estimates the BoM for 20+ different datacenter designs broken down into 70+ equipment types and lays out the impact for 500+ suppliers. It is built on our industry-leading Datacenter Model which forecasts quarter-by-quarter MWs for 6000+ datacenters and anticipates design changes.

This has enabled us to successfully call out both winners, and companies inaccurately pictured as losers by the market, before anyone else. If you are wondering whether UPS systems have a place in upcoming 800VDC distribution, what is the market opportunity for SSTs, or which suppliers are leading this transition, stick with us.

Part 1 of this 800VDC Revolution series covers datacenter layout and equipment implications. Part 2 will focus on power electronics and the semiconductor revolution underneath it.

### Understanding The Basics: What is 800VDC and Why It’s Inevitable
At its simplest, 800VDC in this context means distributing power at ~800 volts direct current through the data hall or row and into the rack, then stepping it down near the compute. The number 800 is not arbitrary, but a voltage high enough to materially reduce current (and therefore copper loss and thermal burden) while remaining within the broad regulatory and product-safety classification of “low-voltage DC” in many jurisdictions. For context, EU rules around the Low Voltage Directive scope reference DC equipment ratings up to 1,500 V DC (and AC up to 1,000 V).

Current datacenter electrical architectures generally rely on AC distribution at the facility level. Datacenters today use three-phase AC at 415V or 480V, and the topology relies on conventional UPS architectures before distributing 48-54V DC within the rack.

This works at today’s rack power levels, but starts to fail as rack densities in the next two years approach ~600 kW+, for several reasons:

**Copper becomes unmanageable at 48–54 V.** A 1 MW rack at 48–54 VDC needs ~200 kg of copper busbars. At 1 GW scale, that’s hundreds of tons of copper — brutal on cost, weight, installation complexity, and routing space.

**Power shelves crowd out compute.** Today’s NVL72 racks already use up to 8 power shelves. At Kyber-class rack power, a 48–54V approach would require ~64U-equivalent of power hardware, effectiviely an entire rack, leaving no volume for compute.

**Current becomes the real limiter.** Delivering 600 kW at 48–54 V implies ~12,500A. At 800 V, that drops to ~750 A (~16.7× less), enabling dramatically smaller conductors/busbars and far lower thermal stress. If conductor resistance were held constant, I²R losses fall ~278×, so in practice you shrink copper and “buy” size/weight reductions.

**Conversion losses compound and hurt reliability.** Stacked AC-to-DC and DC-to-DC stages reduce end-to-end efficiency, increase heat, and introduce failure points, raising cooling loads, downtime risk, and maintenance costs.

At the end of the day, 800VDC is the physics enabler for 2,300W TDP chips and 600kW racks, and those 600kW racks are the direct consequence of the push for density, because density is what drives cost per token down. Cost per token is dictated by the size of the scale-up world you can build at full NVLink bandwidth: bigger domains mean wider Expert Parallelism (EP) / Tensor Parallelism (TP), MoE routing on NVLink rather than scale-out, and less serialization across decode. As we laid out in our Vera Rubin Deep Dive and GTC 2026 pieces, Nvidia’s design rule is to pack compute tightly enough that copper reaches everything in the rack. Reiner Pope made this point cleanly on our friend Dwarkesh’s podcast a few weeks ago, indicating that a single rack bounds the size of the expert layer you can build, because the moment an all-to-all crosses a rack boundary, it falls onto a scale-out fabric that is roughly eight times slower than NVLink.

Bigger scale-up worlds mean denser racks, denser racks mean 600kW envelopes, and 800VDC is what makes those envelopes possible.

### The Four Chapters of the HVDC Transition
The move to 800VDC is a complex metamorphosis that rewrites the entire electrical architecture, introduces new safety standards, requires new regulatory frameworks, and, most importantly, forces operators to make very different strategic choices about when to walk away from their legacy AC distribution.

We frame the 800VDC transition as progressing through four distinct phases. Phases 1 and 2, starting in late 2026 / early 2027, retrofit the existing AC distribution into 800VDC at the rack level via the power rack. Phase 1 is the early-mover stage, driven by hyperscalers willing to pay up for future-proofing and efficiency gains. Phase 2 kicks in once 800VDC-native systems begin shipping at volume. Phase 3 rewrites the electrical architecture itself, taking 800VDC distribution facility-wide. Phase 4 is the end state, built around new pieces of equipment that promise to render much of today’s electrical stack obsolete.

The result is a progressive adoption curve for 800VDC. We expect total incremental capacity powered by 800VDC to reach ~39GW by 2030. Through Phases 1 and 2, all addressable capacity is served by sidecars, since the underlying facility is still AC-distributed and the conversion happens at the power rack. The mix inflects in 2029 as facility-level HVDC distribution becomes viable and the first 800VDC-native sites come online, shifting the conversion stage upstream from the rack to the SST or MV rectifier.

### Phase 1 (2026/2027): The White Space Retrofit
The HVDC journey begins primarily with two operators, Google and Meta. Both have been pushing their 800VDC architectures through the OCP working groups for over 18 months, most visibly with the Mt. Diablo reference design, first announced in October 2024 and published as an open specification in May 2025. Neither is being forced into the transition, but they are doing it to take a leading position in the upcoming shift and because they want to squeeze every megawatt and every point of efficiency out of their existing power chain before the rest of the market is forced to catch up.

This matters because 800VDC is not yet a hard requirement. The chip generations ramping in late 2026 and 2027, like Vera Rubin NVL72, top out at rack densities of 180-220kW. Three-phase AC can still deliver that without hitting the physical limits of conductor sizing or distribution losses. Phase 1 is therefore voluntary future-proofing, not a forced response to a hardware constraint.

This initial phase kicks off the “White Space Retrofit” era. New HVDC hardware, primarily a row-level cabinet called the HVDC power rack, layers on top of existing white space infrastructure rather than replacing it. The datacenter’s electrical backbone stays intact. Same transformers, same UPS, same switchgear, same ATS.

#### Power Flow Overview with HVDC Power Rack
At the facility level, Medium-voltage AC enters the grey space and is stepped down via transformer to 415V or 480V three-phase AC. That feeds into a UPS, which performs double conversion (AC-DC-AC), then outputs 415V AC. AC is then distributed through the data hall via busway. So far, this is the traditional power flow we have extensively covered in previous articles.

The change occurs when we get closer to the IT racks. Instead of feeding 415V directly into in-rack power supply units, the AC feed now terminates at a standalone 42U cabinet named the HVDC power rack deployed at the row level.

The rack receives AC from the overhead busway and outputs 800VDC through cable to adjacent IT racks. Inside, it performs three jobs: rectification of 415V AC to 800VDC, BBU modules for ride-through during outages, and optionally, capacitor shelves for transient buffering during GPU load spikes.

#### In a Nutshell: The Power Rack
It is worth looking in more detail into the building block that underpins Phases 1 and 2 of the 800VDC transition: the disaggregated power rack. This is a dedicated rack that consolidates AC-to-DC rectification, energy storage (BBU and/or capacitor bank), and power management into a single unit, freeing the compute rack to be entirely dedicated to GPUs, networking, and cooling. Microsoft’s Mt Diablo project originated the concept; the OCP Diablo 400 specification, co-authored by Google, Meta, and Microsoft, standardizes it.

**ORv3 HPR V3: The Disaggregation Threshold (50V Sidecar, up to 300 kW)**
HPR V3 is really where power and compute separate into distinct racks, the genesis of the “sidecar” concept. PSU and BBU shelves move into a dedicated 50VDC side power rack connected to the IT rack through horizontal busbars at the top and bottom of both. Both remain ORv3 HPR standard form factor. Power capacity tops out at 300 kW, limited by the horizontal crosslinks and the air-cooled vertical busbar inside the power rack.

The V3 power rack can be serviced independently, shrinking the blast radius of power-side failures. But V3 still distributes at 50VDC, which means busbar currents remain high (6,000A at 300 kW) and the crosslinks become the bottleneck.

**ORv3 HPR V4: HVDC Sidecar at +/-400VDC (up to 800 kW)**
HPR V4 is the version that bridges the OCP HPR lineage into the HVDC era. It makes two critical changes: the voltage steps up from 50VDC to +/-400VDC (800V total), and the busbar-based crosslink is replaced with discrete power cables.
* **Architecture:** PSU and BBU shelves move into a +/-400VDC side power rack, which also houses AC input and DC output PDUs
* **Power delivery:** The power rack connects to the IT rack through 16x 50 kW HVDC cables
* **Power capacity:** Up to 800 kW maximum.

**The Diablo 400 Specification: Standardizing the HVDC Sidecar**
The Diablo 400 specification formalizes and standardizes the HVDC sidecar concept that HPR V4 pioneered. Co-authored by Google, Meta, and Microsoft.

* **Multi-vendor interoperability**
* **Dual voltage support:** The base specification defines +/-400VDC bipolar as the standard configuration
* **Power range:** 100 kW to 1 MW per IT rack
* **PSU design:** 3-phase AC input, +/-400VDC output.

**No One-Size-Fits-All**
There is no one-size-fits-all 800VDC power rack. Nvidia sits entirely outside it and is developing a monopolar 800V reference design at 660kW.

**The cost of the power rack**
We estimate the ASP for the Power Rack to reach $400-500k per unit.

### Phase 2 (2027/2028): The Turning Point Comes with 800VDC-Native Compute
Phase 1 was the start of the retrofit era. The real inflection point comes with the arrival of 800VDC-native systems. Operators electrifying the Kyber Rack have no AC fallback at the rack inlet.

Architecturally, Phase 2 looks very similar to Phase 1. Both retrofit the white space with the HVDC power rack, both leave the grey space intact. The key difference is where the voltage steps down to chip-usable levels. In Phase 2 (Kyber rack), the 800VDC bus runs directly to the compute blade, and an on-blade power module handles the final step-down to 50V.

#### What Happens With UPS and Battery Storage
In the 800VDC architecture, we expect centralized Low Voltage UPS systems to progressively lose their role and eventually become obsolete. In the retrofit era, the power rack sits directly on the 800VDC bus and houses BBU modules and supercapacitors.

### Phase 3 (late 2028/2029): Redesigning the Electrical Architecture With a Centralized Rectifier
In Phase 3, 800VDC becomes the building’s electrical core. 

#### What Happens in the Grey Space: Power Distribution Goes DC
In Phase 3 a dedicated upstream rectifier that sits in the grey space or outdoors converts 415V AC to 800VDC, distributing DC across the entire hall. 

#### What Happens in the White Space: From the Power Rack to the Battery Rack
In Phase 3 we no longer need the Power Rack doing the 800VDC conversion. Instead, we salute a new friend, the battery rack.
The battery rack shares most of the power rack’s components and functions but receives 800VDC directly from the grey space.

### Phase 4 (>2029): SSTs, the End-State
Finally, we get to the holy grail of DC power distribution: Solid State Transformers, or SSTs. These are a new category of power electronic devices that replace conventional iron-core transformers with high-frequency, semiconductor-based converters.

#### In a Nutshell: Solid-State Transformers
An SST does the same job as the massive iron-and-copper transformers but uses semiconductor switching stages. 
* **Input stage:** converts AC to DC.
* **Isolation stage:** high-frequency transformer.
* **Output stage:** produces final 800VDC.

Pros: Energy efficiency (targeting 99%), dramatically smaller (14x size reduction, 40x weight reduction), programmable, multi-port topology.

#### Datacenter Layout Implications
The SST eliminates the LV equipment and the Phase 2 rectifier. Expected SST cost of ~$1.0-1.5M/MW.

### Datacenter Layout Summary: Total Cost Barely Moves, Content Shifts, Efficiency Climbs
Total electrical content per MW stays in a $3.6-4.8M band across architectures. 
Efficiency increases from 82.0% (baseline) to 87.4% (Phase 4).

### The Other Side of the 800VDC Transition: Challenges and Limitations
#### Challenge 1: Regulation, Safety and Grounding
**Regulation:** Full 800VDC code support targets NEC 2029.
**Safety:** The biggest safety risk is arc flash. IEEE 1584 does not cover DC.
**Grounding:** High-resistance grounding vs solid grounding vs floating.

(Note: Text was truncated here in the source provided).
