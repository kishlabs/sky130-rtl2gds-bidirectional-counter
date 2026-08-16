# scripts/placement.tcl

# ---- 1. READ: pick up from where power planning left off ----
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def pd/pdn.def
read_sdc constraints/counter.sdc

# ---- 2. GLOBAL PLACEMENT: analytic, approximate - cells may overlap ----
global_placement -density 0.60

# ---- 3. DETAILED PLACEMENT: legalize onto real rows/sites, no overlaps ----
detailed_placement

# ---- 4. Verify legality directly - don't just trust it worked ----
check_placement

# ---- 5. Output ----
write_def pd/placement.def
