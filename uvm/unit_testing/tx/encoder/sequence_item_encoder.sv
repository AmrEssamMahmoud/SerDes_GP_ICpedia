package sequence_item_encoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_encoder extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_encoder)

        rand data_symbol input_data;
        rand bit TxDataK;
        bit [9:0] output_data;

        function new (string name = "sequence_item_encoder");
            super.new(name);
        endfunction : new
  
        constraint data_k_const {
            TxDataK dist {1:=10, 0:=90};
        }
        
        constraint  k_const {
            if (TxDataK == 1) input_data inside {
                S_28_0, S_28_1, S_28_2, S_28_3, S_28_4, S_28_5, S_28_6, S_23_7, S_27_7, S_28_7, S_29_7, S_30_7
            }; 
        }
        
    endclass
endpackage