vlib work
vlog designs/tx/PISO.v testbenchs/tx/PISO_tb.v
vsim -voptargs=+acc work.PISO_tb
add wave *
run -all
