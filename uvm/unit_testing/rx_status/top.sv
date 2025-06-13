import uvm_pkg::*;
`include "uvm_macros.svh"
module top;
    bit clk;
    always clk=#5~clk;
    rx_statusifc ifc(.clk(clk));
    receiver_status dut(
        .underflow(ifc.dut.underflow),
        .overflow(ifc.dut.overflow),
        .skip_added(ifc.dut.skip_added),
        .skip_removed(ifc.dut.skip_removed),
        .Disparity_Error(ifc.dut.Disparity_Error),
        .Decode_Error(ifc.dut.Decode_Error),
        .receiver_detected(ifc.dut.receiver_detected),
        .rx_status(ifc.dut.rx_status)
    );
    initial begin
        uvm_config_db#(virtual ifC)::set(0, "*", "ifc", ifc);
        run_test();
        assertions(ifc);
        $dumpfile("test.vcd");
        $dumpvars(0, top);
    end
endmodule