vlib work
vlog -timescale 1ns/1ns part1.v
vsim part1
log {/*}
add wave {/*}

force {SW[0]} 0
run 10ns

force {SW[0]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {KEY} 0 0 ns, 1 15 ns -repeat 30
run 1200ns