import uvm_pkg::*;
`include "uvm_macros.svh"
import PISO_test_pkg::*;
module PISO_top();

bit clk ;

always  begin
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
end

PISO_Interface PISO_if(clk);

PISO PISO_DUT (PISO_if);

// bind PISO PISO_assertions PISO_SVA (PISO_if);

initial begin
    uvm_config_db#(virtual PISO_Interface)::set(null, "*", "PISO_IF", PISO_if);
    run_test("PISO_test");
end



endmodule