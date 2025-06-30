//DUT
../hdl/designs/rx/elastic_buffer/buffer_memory.sv
../hdl/designs/rx/elastic_buffer/buffer_write.sv
../hdl/designs/rx/elastic_buffer/buffer_read.sv
../hdl/designs/rx/elastic_buffer/synchronizer.sv
../hdl/designs/rx/elastic_buffer/elastic_buffer.sv

//interface
enums_pkg.sv
unit_testing/rx/elastic_buffer/buffer_if.sv
unit_testing/rx/elastic_buffer/assertions_buffer.sv

//UVM
unit_testing/rx/elastic_buffer/sequence_item_buffer.sv
unit_testing/rx/elastic_buffer/sequence_buffer.sv
sequencer.sv
unit_testing/rx/elastic_buffer/driver_buffer.sv
unit_testing/rx/elastic_buffer/monitor_buffer.sv
unit_testing/rx/elastic_buffer/agent_buffer.sv
unit_testing/rx/elastic_buffer/scoreboard_buffer.sv
env.sv
test.sv
top.sv
