//DUT
../hdl/designs/tx/encoder.sv
../hdl/designs/tx/PISO.sv
../hdl/designs/rx/decoder.sv
../hdl/designs/rx/SIPO.sv
../hdl/designs/equalization_top_module.sv

analog_blocks/tx/equalizer.sv
analog_blocks/common/channel.sv

//interface
enums_pkg.sv
integration_testing/equalization_top/equalization_top_if.sv
integration_testing/equalization_top/assertions_equalization_top.sv

//UVM
integration_testing/equalization_top/sequence_item_equalization_top.sv
integration_testing/equalization_top/sequence_equalization_top.sv
sequencer.sv
integration_testing/equalization_top/driver_equalization_top.sv
integration_testing/equalization_top/monitor_equalization_top.sv
integration_testing/equalization_top/agent_equalization_top.sv
integration_testing/equalization_top/scoreboard_equalization_top.sv
env.sv
test.sv
top.sv
