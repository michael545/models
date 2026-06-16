# 800VDC & AI Data Center Vendor Map

This document tracks the key players across the emerging 800VDC data center ecosystem, categorized by their primary component offerings.

## 1. Solid-State Transformers (SSTs)
SSTs are the "holy grail" of Phase 4 distribution, converting medium-voltage grid AC directly to 800VDC, replacing massive iron-core transformers and LV rectifiers.

### Pure-Play & Startups
* **DG Matrix:** Backed by ABB, utilizing Infineon SiC. Only SST currently included in Nvidia's MGX reference architecture.
* **Amperesand:** Targeting 30MW of commercial deployments in 2026.
* **Heron Power:** Building a 40GW US manufacturing facility for its 4.2MW "Heron Link" units.
* **Novos Power:** Focuses on direct MV-to-800VDC SSTs with air cooling and 50% smaller footprints.

### Incumbents
* **Eaton:** Acquired Resilient Power Systems (August 2025) to immediately buy into SST expertise.

### New Entrants (June 2026)
* **Enphase Energy:** Launched the "IQ Solid-State Transformer" platform targeting 98.5% efficiency. Marketing focus is on using distributed SST architecture to eliminate traditional UPS systems entirely.
* **SolarEdge:** Entering the datacenter SST market, leveraging their massive scale in power electronics and solar inverters.

---

## 2. Battery Energy Storage Systems (BESS) & Microgrids
As diesel generators are phased out and AI load transients increase, gigawatt-scale BESS is becoming mandatory.

* **Fluence Energy (FLNC):** Co-authored the 136MW NVL72 Reference Architecture with Siemens and Nvidia. Provides the "Smartstack" BESS.
* **Tesla:** Megapack deployments increasingly targeting data center colocation sites.
* **ON.energy:** Recently patented a Medium Voltage double-conversion UPS architecture.

---

## 3. HVDC Protection & Switchgear
Interrupting 800VDC under load creates sustained arcs. Next-generation Solid State Circuit Breakers (SSCBs) and advanced switchgear are required.

* **ABB:** SACE Infinitus (solid-state, 1000V/2500A) adapted for data centers in partnership with Nvidia.
* **LS Electric:** Expanding 800VDC component testing and UL-certified DC molded case circuit breakers.
* **HD Hyundai Electric & Hyosung:** South Korean heavyweights aggressively entering the Nvidia 800VDC supply chain ecosystem (June 2026 acceleration).
* **EPEC Solutions:** Publicly marketing 800VDC LV switchboards.

---

## 4. Power Racks & Sidecars
The backbone of Phase 1 and Phase 2 "retrofit" architectures, stepping 415VAC down to 800VDC at the row level (OCP Diablo 400 spec).

* **Delta Electronics:** Unveiled 110kW power shelves with embedded 80kW BBU capacity at GTC 2026. Also building 2.4MW In-Row CDUs natively supporting 800VDC.
* **Advanced Energy**
* **Artesyn / Lite-On**
