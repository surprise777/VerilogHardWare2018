vlib work
vlog -timescale 1ps/1ps ram32x4.v
vsim -L altera_mf_ver ram32x4
log {/*}
add wave {/*}


force {clock} 0 0, 1 2 -repeat 4
force {wren} 0 0, 1 4, 0 12 -repeat 16
run 40ps

force {address} 2#00000
force {data} 2#0000
run 4ps

force {address} 2#00001
force {data} 2#0001
run 4ps

force {address} 2#00010
force {data} 2#0010
run 4ps


force {address} 2#00011
force {data} 2#0011
run 4ps


force {address} 2#00000
force {data} 2#0100
run 4ps

force {address} 2#00001
force {data} 2#0101
run 4ps

force {address} 2#00010
force {data} 2#0110
run 4ps

force {address} 2#00011
force {data} 2#0111
run 4ps

force {address} 2#00000
force {data} 2#1000
run 4ps

force {address} 2#00001
force {data} 2#1001
run 4ps












