vlib work
vlog -timescale 1ns/1ns par2.v
vsim par2
log {/*}
add wave {/*}

force {SW[3]} 0
run 10ns

force {SW[3]} 1
run 10ns

force {SW[2]} 1
run 10ns

force {SW[1]} 0
run 10ns

force {CLOCK_50} 0 0, 1 1 -repeat 2
run 50ns

force {SW[0]} 1
run 10ns

force {SW[3]} 0
run 10ns

force {SW[3]} 1
run 200ns


force {SW[3]} 0
run 10ns

force {SW[0]} 0
run 10ns

force {SW[3]} 1
run 200ns


force {SW[3]} 0
run 10ns

force {SW[1]} 1
run 10ns

force {SW[3]} 1
run 200ns


force {SW[3]} 0
run 10ns

force {SW[0]} 1
run 10ns

force {SW[3]} 1
run 200ns







