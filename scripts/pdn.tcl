# scripts/pdn.tcl

# ---- 1. READ: pick up from where floorplanning left off ----
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def pd/floorplan.def

# ---- 2. Tell OpenROAD which real cell pins are power/ground ----
add_global_connection -net VDD -pin_pattern "^VPWR$" -power
add_global_connection -net VDD -pin_pattern "^VPB$"
add_global_connection -net VSS -pin_pattern "^VGND$" -ground
add_global_connection -net VSS -pin_pattern "^VNB$"
set_voltage_domain -power VDD -ground VSS

# ---- 3. Define the grid policy ----
define_pdn_grid -name "core_grid"

# met1 rails: width well above Sky130's 0.14um minimum for this layer
add_pdn_stripe -followpins -layer met1 -width 0.48

# met4 straps: single layer is enough for a die this small;
# met5 deliberately skipped (its 1.6um minimum width is
# disproportionate to our ~30x30um core)
add_pdn_stripe -layer met4 -width 0.5 -pitch 12 -offset 2

# ---- 4. Connect layers ----
add_pdn_connect -layers {met1 met4}

# ---- 5. Build it ----
pdngen

# ---- 6. Output ----
write_def pd/pdn.def
