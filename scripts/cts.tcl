# scripts/cts.tcl

# ---- 1. READ: pick up from placement ----
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def pd/placement.def
read_sdc constraints/counter.sdc

# ---- 2. Tell CTS which layer to model clock wire RC on ----
set_wire_rc -clock -layer met3

# ---- 3. Restrict CTS to real clock buffer cells, not generic logic buffers ----
set_dont_use sky130_fd_sc_hd__buf_*
set_dont_use sky130_fd_sc_hd__inv_*

# ---- 4. Build the clock tree ----
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 \
                      -buf_list {sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2} \
                      -sink_clustering_enable

# ---- 5. Fix any leftover long wire from the clock pin to the tree root ----
repair_clock_nets

# ---- 6. Re-legalize - CTS just added new buffer cells with no legal position yet ----
detailed_placement

# ---- 7. From here on, STA uses the REAL clock tree delay, not an
#          idealized estimate ----
set_propagated_clock [all_clocks]

# ---- 8. Reports - the actual verification ----
report_cts
report_clock_skew

# ---- 9. Output ----
write_def pd/cts.def
