box 0 0 0 0
drc off
snap int

lef read /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
lef read /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

gds readonly true
gds rescale false
gds read /home/kumar/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

def read pd/routed.def
load up_down_counter
select top cell
expand

gds write results/up_down_counter.gds
quit -noprompt
