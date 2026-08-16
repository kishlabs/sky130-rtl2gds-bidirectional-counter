# scripts/floorplan.tcl

# ---- 1. READ: technology + cell physical views (LEF, not liberty) ----
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# ---- 2. READ: timing library (needed downstream, load it now) ----
read_liberty /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ---- 3. READ: your synthesized netlist ----
read_verilog synth/up_down_counter_synth.v
link_design up_down_counter

# ---- 4. READ: your timing constraint ----
read_sdc constraints/counter.sdc

# ---- 5. TECH-SPECIFIC GEOMETRIC PROCESSING: define die/core area ----
initialize_floorplan -utilization 45 -aspect_ratio 1.0 -core_space 2 -site {unithd}

make_tracks

# ---- 6. Place I/O pins on the die boundary ----
place_pins -hor_layers met3 -ver_layers met2

# ---- 7. OUTPUT ----
write_def pd/floorplan.def
