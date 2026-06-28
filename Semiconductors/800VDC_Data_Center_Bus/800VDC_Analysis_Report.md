# 800VDC Data Center Architecture & Component Analysis

## 1. Overview of 800VDC Power Delivery
The transition to 800VDC is driven by the physical limits of current data center designs as AI workloads push rack densities to 600kW+ (e.g., NVIDIA Kyber Ultra). Supplying this massive power at legacy 48-54VDC requires unmanageable amounts of copper (up to 200kg per 1MW rack) and results in massive I²R resistive losses. By raising the voltage to 800VDC, current is reduced by ~16.7x compared to 48V, dramatically reducing copper requirements (by ~45%) and improving facility-level efficiency by eliminating intermediate conversion stages (AC-DC-AC-DC).

The transition happens across 4 phases:
1. **Phase 1 (Retrofit):** AC is delivered to the row, then converted to 800VDC by a dedicated HVDC Power Rack (e.g., OCP Diablo 400).
2. **Phase 2 (Native):** 800VDC is delivered directly to compute blades, with on-blade step-down modules.
3. **Phase 3 (Centralized DC):** Rectification to 800VDC happens in the grey space; DC is distributed facility-wide.
4. **Phase 4 (SST End-State):** Solid-State Transformers (SSTs) directly step down medium-voltage grid AC to 800VDC, replacing heavy iron-core transformers and rectifiers.

---

## 2. Reference Designs
The documents outline several major reference architectures pushing the 800VDC standard:
* **OCP Diablo 400:** Co-authored by Google, Meta, and Microsoft. Standardizes the HVDC sidecar/power rack architecture (+/-400VDC bipolar output, scaling from 100kW to 1MW per IT rack).
* **Mt. Diablo:** The Microsoft-led project that originated the OCP Diablo 400 specification.
* **NVIDIA DSX Vera Rubin (NVL72):** Uses an 800V monopolar reference design targeting up to 660kW per rack.
* **Fluence (FLNC) 136MW Blueprint:** A joint architecture by Fluence, Siemens, and NVIDIA. It incorporates gigawatt-scale Battery Energy Storage Systems (BESS) at the core of the facility to handle severe millisecond-to-second AI load transients (preventing grid destabilization) and bypass interconnection bottlenecks.

---

## 3. Component & BOM Analysis
*(Note: The provided documentation focuses on system-level architecture and vendor mapping. Low-level schematic BOMs like exact values for MLCCs, specific inductor turns, or individual MCU part numbers are not explicitly listed in these high-level architectural files. However, we can extrapolate their systemic roles based on the text.)*

### Power Electronics & Semiconductors
* **Silicon Carbide (SiC) & Gallium Nitride (GaN) FETs:** Crucial for the high-voltage, high-frequency switching required in 800VDC environments. They are the core of **Solid-State Circuit Breakers (SSCBs)** for microsecond fault interruption, and **Solid-State Transformers (SSTs)** (e.g., DG Matrix uses Infineon SiC). 
* **LLC Resonant Converters:** While not explicitly named, these are the fundamental topologies used in the Power Rack's AC-to-DC rectification and the Phase 2 on-blade step-down converters to ensure high efficiency and minimal switching losses.
* **Supercapacitors & Battery Backup Units (BBU):** Housed within the HVDC Power Racks to provide transient buffering during violent GPU load spikes (swinging 30% to 100% in milliseconds) and short-term ride-through energy.

### Passives & Electromechanical
* **Copper Busbars & Conductors:** 800VDC allows moving away from massive horizontal busbars to discrete power cables (e.g., 16x 50kW HVDC cables connecting the power rack to the IT rack in HPR V4). Overall facility copper use drops by ~45%.
* **Blind-Mate Cable Connectors ("Whips"):** High-tension connectors that face extreme thermal cycling due to high currents and are actively monitored for loosening joints.

### Sensing & Control (MCUs, ADCs, Sensors)
* **High-Precision ADCs:** Used in conjunction with resistive leak cables under cooling units. If conductive liquid drips, the ADCs detect a resistance drop and trigger a millisecond shutdown of the server motherboard to prevent massive shorts.
* **EMI-Immune Voltage & Current Sensors:** Essential for precision 800VDC telemetry. AI workloads generate massive load spikes; a measurement deviation of merely 0.5% on the 800VDC bus can distort load management and cause unnecessary compute throttling.

---

## 4. Niche Technologies, Protection, and Suppliers

### Advanced Inspection & Physical AI
Given the lethal nature of 800VDC combined with Direct Liquid Cooling (DLC), facilities utilize autonomous quadruped robots (e.g., Boston Dynamics, ANYbotics) rather than humans for continuous patrol.
* **Acoustic Beamforming (MEMS Sensors):** Arrays of up to 64 ultrasonic microphones listen for the high-frequency hiss of pressurized micro-coolant leaks or the sound of "partial discharge" inside 800VDC cables (which precedes arc flashes).
* **Radiometric Thermal Sweeps:** Robots scan busbar joints and connectors. Thermal cameras detect slight warming caused by thermal cycling loosening mechanical joints, enabling preventative maintenance.
* **Vapor Sniffing:** For immersion cooling or dielectric refrigerants, robots use gas concentration sensors to detect microscopic, invisible vapor leaks.

### Solid-State Transformers (SSTs)
SSTs represent the endgame (Phase 4), shrinking transformers by 14x and reducing weight by 40x.
* **Niche Suppliers:** **DG Matrix** (backed by ABB, in NVIDIA's MGX spec), **Amperesand**, **Heron Power**, and **Novos Power**.
* **Incumbents Entering:** Eaton (via acquisition of Resilient Power Systems), Enphase Energy, and SolarEdge.

### Solid-State Circuit Breakers (SSCBs)
Mechanical breakers are too slow to extinguish 800VDC arcs safely. SSCBs use SiC/GaN to interrupt faults in microseconds.
* **Key Players:** **ABB** (SACE Infinitus 1000V/2500A), **LS Electric**, **HD Hyundai Electric**, **Hyosung**, and **EPEC Solutions**.

### Battery Energy Storage Systems (BESS)
Gigawatt-scale BESS is becoming mandatory to smooth AI load transients and phase out diesel generators.
* **Key Players:** **Fluence Energy (FLNC)** (Smartstack in the 136MW reference architecture), **Tesla** (Megapacks for colocation), and **ON.energy**.
