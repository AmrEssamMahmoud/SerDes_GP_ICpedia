vlib work
vlog designs/tx/encoder.v testbenchs/tx/encoder_tb.v
vsim -voptargs=+acc work.encoder_tb
add wave *
run -all
