vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector
log {/*}
add wave {/*}

force {SW[0]} 1
run 100ns

force {SW[1]} 0
run 10ns

force {KEY[0]} 0 0, 1 5 -repeat 10
run 150ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 0
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 0
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {SW[0]} 0
run 10ns

force {SW[0]} 1
run 30ns