# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in hexDisplay.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns hexDisplay.v

# Load simulation using hexDisplay as the top level simulation module.
vsim hexDisplay

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# a should be high
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
# Run simulation for a few ns.
run 10ns

# b should be high
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
run 10ns


# c should be high
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
run 10ns

# 1 should be high
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 10ns

# 2 should be high
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 10ns

# 3 should be high
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 10ns

