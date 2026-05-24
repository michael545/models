#set page(paper: "a4")
#set text(font: "New Computer Modern", size: 12pt)

= 800VDC Data Center Bus Study

== Facility Distribution (800V DC)
- *Voltage:* 800V DC
- *Component:* Copper busbars distribute this 800V directly to the compute racks. At 10,000 total amps, this requires substantial busing, but it is vastly more manageable than legacy AC systems.

== Rack-Level Conversion (DC to DC)
- *Input:* 800V DC | *Output:* 48V DC (or 54V DC)
- *Current:* 166,666 Amps (Distributed across the pod)
- *Component:* Power shelves inside each rack step the 800V down to 48V. Pushing 48V across the facility would require impossible copper thickness, which is why this conversion happens inside the rack.

== Point-of-Load (PoL) at the Chip
- *Input:* 48V DC | *Output:* 1.0V DC (Core Voltage)
- *Current:* 8,000,000 Amps (Distributed across thousands of GPUs)
- *Component:* Voltage Regulator Modules (VRMs) sit millimeters from the AI silicon. A single 1000W GPU operating at 1V draws 1000 Amps locally.

The widget below lets you scale the MW load to see exactly how these voltages and extreme currents shift across the infrastructure.
