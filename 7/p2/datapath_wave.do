vlib work
vlog -timescale 1ns/1ns part2.v
vsim datapath
log {/*}
add wave {/*}


force {clk} 0 0, 1 2 -repeat 4
run 120ns

force {resetn} 1
force {plot} 0
force {ld_x} 0
force {ld_y} 0
force {ld_c} 0
force {data_in} 2#0000001
force {colour} 2#111
run 10ns

force {resetn} 0
force {plot} 0
force {ld_x} 0
force {ld_y} 0
force {ld_c} 0
force {data_in} 2#0000001
force {colour} 2#111
run 10ns

force {resetn} 1
force {plot} 0
force {ld_x} 1
force {ld_y} 0
force {ld_c} 0
force {data_in} 2#0000001
force {colour} 2#111
run 10ns

force {resetn} 1
force {plot} 0
force {ld_x} 0
force {ld_y} 1
force {ld_c} 1
force {data_in} 2#0000010
force {colour} 2#111
run 10ns


force {resetn} 1
force {plot} 1
force {ld_x} 0
force {ld_y} 0
force {ld_c} 0
force {data_in} 2#0000001
force {colour} 2#111
run 80ns


