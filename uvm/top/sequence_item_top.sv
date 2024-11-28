package sequence_item_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_top extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_top)

        rand data_symbol input_data;
        rand bit tx_data_k;
        bit rx_data_k;
        bit [9:0] encoded_data;
        data_symbol output_data;

        function new (string name = "sequence_item_top");
            super.new(name);
        endfunction : new

        constraint tx_data_k_const {
            tx_data_k dist {1:=0 ,0:=100};
        }

    endclass
endpackage