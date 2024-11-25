import uvm_pkg::*;
`include "uvm_macros.svh"

module top();

    bit BitCLK_10_Tx, BitCLK_10_Rx, BitCLK;

    initial begin
        BitCLK_10_Rx = 0;
        #3;
        forever begin
            #10 BitCLK_10_Rx = ~BitCLK_10_Rx;
        end
    end
    initial begin
        forever begin
            #10 BitCLK_10_Tx = ~BitCLK_10_Tx;
        end
    end
    initial begin
        forever begin
            #1 BitCLK = ~BitCLK;
        end
    end

    top_if top_if (BitCLK, BitCLK_10_Tx, BitCLK_10_Rx);
    top_module top_module (
        .BitCLK(BitCLK),
        .BitCLK_10_Tx(BitCLK_10_Tx),
        .BitCLK_10_Rx(BitCLK_10_Rx),
        .Reset(top_if.Reset),
        .TxDataK(top_if.TxDataK),
        .TxParallel_8(top_if.TxParallel_8),
        .RxDataK(top_if.RxDataK),
        .RxParallel_8(top_if.RxParallel_8)
    );

    initial begin
        uvm_config_db #(virtual top_if)::set(null, "uvm_test_top", "TOP_IF", top_if);
        run_test("top_test");
    end

endmodule