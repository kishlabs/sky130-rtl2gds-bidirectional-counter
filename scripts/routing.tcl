# scripts/routing.tcl

# ---- 1. READ: pick up from CTS ----
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def pd/cts.def
read_sdc constraints/counter.sdc
set_propagated_clock [all_clocks]

# ---- 2. Which layers signals vs. clock are allowed to use ----
# Clock kept off the lowest layer, consistent with the met3 wire-RC
# model we already used during CTS
set_routing_layers -signal met1-met5 -clock met3-met5

# ---- 3. GLOBAL ROUTING: rough, congestion-aware paths per net ----
global_route -congestion_iterations 30


# ---- 4. DETAILED ROUTING: exact tracks + vias, DRC-legal ----
detailed_route -output_drc pd/route_drc.rpt \
                -output_maze pd/route_maze.log \
                -droute_end_iter 20 \
                -verbose 1

# ---- 5. Output ----
write_def pd/routed.def
