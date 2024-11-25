vlib work
vlog designs/rx/decoder.v testbenchs/rx/decoder_tb.v
vsim -voptargs=+acc work.decoder_tb
add wave *
run -all
