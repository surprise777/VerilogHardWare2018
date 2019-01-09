vlib work
vlog -timescale 1ns/1ns part2_test.v
vsim part2
log {/*}
add wave {/*}


force {CLOCK_50} 0 0, 1 2 -repeat 5
run 150ns

force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[1]} 1
force {SW} 2#1110000001
run 10ns

force {KEY[0]} 0
force {KEY[3]} 1
force {KEY[1]} 1
force {SW} 2#1110000001
run 10ns

force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[1]} 1
force {SW} 2#1110000001
run 10ns

force {KEY[0]} 1
force {KEY[3]} 0
force {KEY[1]} 1
force {SW} 2#1110000001
run 10ns


force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[1]} 1
force {SW} 2#1110000010
run 10ns

force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[1]} 0
force {SW} 2#1110000010
run 10ns

force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[1]} 1
force {SW} 2#1110000010
run 90ns

