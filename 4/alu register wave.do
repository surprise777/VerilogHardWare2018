vlib work
vlog -timescale 1ns/1ns part2.v
vsim part2
log {/*}
add wave {/*}

force {SW[9]} 0
run 10ns

force {SW[9]} 1
run 10ns


force {KEY} 0 0 ns, 1 15 ns -repeat 30
run 80ns

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 0

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
run 40ns

