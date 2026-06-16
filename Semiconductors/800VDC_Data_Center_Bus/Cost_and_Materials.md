# 800VDC Economics and Materials Model

This document tracks the capital expenditure (CapEx), operational expenditure (OpEx) savings, and raw material impacts of transitioning from traditional 415V/480V AC distribution to 800VDC architectures.

## 1. Material Savings (Copper Reduction)
As of June 2026, engineering implementations of 800VDC have demonstrated massive raw material savings due to the principle of P=IV. By nearly doubling the voltage (from 415VAC to 800VDC), current is halved, allowing for vastly smaller conductors.

* **Copper Reduction:** Transitioning to 800VDC from traditional 415 VAC systems yields an approximately **45% reduction in copper requirements** across the facility.
* **Scale Impact:** At a 1 GW IT load scale, this prevents the need to route hundreds of tons of copper busbars, significantly easing physical installation, weight loads on raised floors/ceilings, and thermal stress.

## 2. CapEx Profile per MW
The total electrical equipment content per MW remains in a relatively tight band ($3.6M - $4.8M), but the *mix* of equipment shifts drastically depending on the Phase of adoption.

* **Phase 1 & 2 (White Space Retrofit):** Total content peaks slightly as the HVDC Power Rack is added to the row. The Power Rack ASP is roughly **$400k-$500k per unit** (~$500k/MW).
* **Phase 3 (Centralized Rectifier):** Central UPS systems ($1.2M/MW) are eliminated. Central rectifiers are added (~$0.20M/MW).
* **Phase 4 (Solid State Transformers):** Total content rises slightly to ~$4.0M/MW. The SST replaces both the LV transformer and the LV rectifier.
  * **SST Estimated Cost:** **$1.0M - $1.5M / MW**.

## 3. OpEx and Efficiency (PUE Impact)
The primary financial driver of 800VDC is eliminating conversion losses (AC-to-DC-to-AC-to-DC).

* **Baseline AC Efficiency:** ~82.0% (across seven conversion stages).
* **Phase 4 (SST) Efficiency:** ~87.4% (eliminates two stages).
* **Net Delta:** Approximately **5.4% improvement** in facility-level efficiency.

### Translation to Megawatts and Dollars
For a **1 GW (1000 MW)** AI Data Center:
* A 5% efficiency gain translates to roughly **50 MW of continuous grid power saved**.
* At an average industrial electricity rate of $0.07/kWh, 50 MW of continuous power equates to **~$30.6 million in annual OpEx savings**, or simply allows the operator to deploy an additional 50 MW of GPU compute within the same grid interconnect limit.
