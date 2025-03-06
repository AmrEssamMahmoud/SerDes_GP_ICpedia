//DUT
../hdl/designs/tx/encoder.sv
../hdl/designs/tx/PISO.sv
../hdl/designs/rx/decoder.sv
../hdl/designs/rx/SIPO.sv
../hdl/designs/rx/cdr/sampler.sv
../hdl/designs/rx/cdr/phase_detector.sv
../hdl/designs/rx/cdr/loop_filter.sv
../hdl/designs/rx/cdr/cdr.sv
../hdl/designs/cdr_top_module.sv

analog_blocks/rx/cdr/phase_interpolator.sv

//interface
enums_pkg.sv
integration_testing/cdr_top/cdr_top_if.sv
integration_testing/cdr_top/assertions_cdr_top.sv

//UVM
integration_testing/cdr_top/sequence_item_cdr_top.sv
integration_testing/cdr_top/sequence_cdr_top.sv
sequencer.sv
integration_testing/cdr_top/driver_cdr_top.sv
integration_testing/cdr_top/monitor_cdr_top.sv
integration_testing/cdr_top/agent_cdr_top.sv
integration_testing/cdr_top/scoreboard_cdr_top.sv
env.sv
test.sv
top.sv
