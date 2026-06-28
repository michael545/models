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

---

## 5. 800V to 12V DC-DC Conversion (LLC Reference Designs)

The step-down from an 800VDC bus to a 12V intermediate bus is typically achieved using LLC resonant converter topologies, favored for their Zero-Voltage Switching (ZVS) and Zero-Current Switching (ZCS) capabilities which drastically reduce switching losses and EMI. 

Due to the extreme 64:1 voltage conversion ratio (800V to 12.5V), designs often employ advanced semiconductor materials (GaN and SiC) and specific topologies like ISOP (Input-Series Output-Parallel) or bidirectional DCX. Below are notable reference designs and their specific BOM component profiles:

### A. Texas Instruments PMP41037 (1kW Bidirectional DCX)
This reference design functions as an isolated DC transformer converting 800V to 12V, aimed at automotive and industrial applications.
* **Microcontroller (MCU):** **C2000™ TMS320F280039C** real-time MCU, used for precise resonant control.
* **Power FETs:** Uses **LMG3622** 650V GaN half-bridge power stages configured in serial to handle the 800V input.
* **Gate Drivers:** **UCC27524** dual-channel gate drivers.
* **Isolation & Sensing:** **ISO7721** digital isolators, **AMC1311** isolated amplifiers, and **ACS733** current sensors.

### B. STMicroelectronics STDES-6KWHVDCDC (6kW LLC Converter)
A full-bridge LLC resonant converter designed for EV charging and high-voltage infrastructure.
* **Microcontroller (MCU):** **STM32G474RET6** (specifically designed for digital power conversion).
* **Power MOSFETs (Primary Side):** **STW40N95DK5** MDmesh DK5 Power MOSFETs.
* **Rectification Diodes:** **STPSC40H12CWL** Silicon Carbide (SiC) Schottky diodes.
* **Gate Driving:** Uses **PM8834MTR** gate driver ICs with isolated gate drive transformers.

### C. EPC (Efficient Power Conversion) 6kW ISOP Converter
To avoid using less efficient 1200V+ SiC components, this architecture divides the voltage stress using stacked modules.
* **Topology (ISOP):** By stacking eight LLC modules (Input-Series Output-Parallel), the complex 64:1 conversion is reduced to a 100V to 12.5V step per module.
* **GaN FETs:** This configuration allows the use of lower voltage, higher-efficiency GaN FETs (e.g., EPC's 100V/200V eGaN devices) instead of high-voltage parts.
* **Transformers & Passives:** Utilizes planar transformers integrated into the PCB for high power density and thermal management. Synchronous Rectification (SR) is heavily relied upon to handle the massive currents at the 12V output.

*(Note: For explicit inductor (L), capacitor (C - including MLCCs), and fuse values, the Bill of Materials (BOM) files in the TI PowerLab (PMP41037) or ST product documentation (STDES-6KWHVDCDC) contain exact schematic-level part numbers.)*

### D. Deep Dive on Passive & Electromechanical Components in 800V-to-12V LLCs
To fully realize these designs, specific classes of passive components must be utilized to survive the extreme voltage differentials and high output currents:
* **Fuses:** 800VDC systems require specialized DC-rated fuses (e.g., from Littelfuse or Eaton Bussmann) designed to extinguish DC arcs without relying on a zero-crossing. These are typically ceramic tube, sand-filled fuses placed on the high-voltage input stage.
* **MLCCs (Multi-Layer Ceramic Capacitors):** Used heavily for high-frequency decoupling and snubber circuits. On the primary (800V) side, they must be rated for at least 1000VDC (e.g., Murata or TDK high-voltage series). On the secondary (12V) side, banks of lower-voltage, high-capacitance MLCCs handle the massive output ripple currents.
* **Electrolytic Capacitors:** Employed on the 800V input bus for bulk energy storage and low-frequency filtering. Due to voltage limits, these are often placed in series (with balancing resistors) to handle the 800V stress.
* **Inductors & Transformers:** The LLC topology relies on a resonant inductor (Lr) and magnetizing inductance (Lm). High-power density designs (like the EPC or TI models) utilize custom **planar transformers** (e.g., custom wound YXS61615T for the TI board) where the "windings" are actually heavy copper traces embedded directly into the multi-layer PCB, rather than traditional wire-wound bobbins.
* **Copper Traces (PCB):** The secondary side outputting 12V handles hundreds of amps. To manage this without melting, PCBs use heavy copper (e.g., 3 oz to 4 oz copper layers), thermal vias, and exposed copper planes mated directly to liquid cold plates for extreme thermal extraction.
