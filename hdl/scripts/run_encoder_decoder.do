vlib work
vlog designs/tx/encoder.v designs/rx/decoder.v testbenchs/encoder_decoder_tb.v
vsim -voptargs=+acc work.encoder_decoder_tb
add wave *
run -all
