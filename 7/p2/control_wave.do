vlib work
vlog -timescale 1ns/1ns part2.v
vsim control
log {/*}
add wave {/*}


force {clk} 0 0, 1 2 -repeat 5
run 70ns

force {resetn} 1
force {go} 1
force {write} 1
run 10ns

force {resetn} 0
force {go} 1
force {write} 1
run 10ns

force {resetn} 1
force {go} 1
force {write} 1
run 10ns

force {resetn} 1
force {go} 0
force {write} 1
run 10ns


force {resetn} 1
force {go} 1
force {write} 1
run 10ns

force {resetn} 1
force {go} 1
force {write} 0
run 10ns

force {resetn} 1
force {go} 1
force {write} 1
run 10ns

