vlib work
vlog designs/rx/SIPO.v testbenchs/rx/SIPO_tb.v
vsim -voptargs=+acc work.SIPO_tb
add wave *
run -all
