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

        covergroup input_coverage;
			symbols: coverpoint input_data;
		endgroup

        function new (string name = "sequence_item_top");
            super.new(name);
            input_coverage = new();
        endfunction : new

        constraint tx_data_k_const {
            tx_data_k dist {1:=10, 0:=90};
        }
        constraint  k_const {
            if(tx_data_k == 1)
                input_data inside {S_28_0, S_28_1, S_28_2, S_28_3, S_28_4, S_28_5, S_28_6, S_23_7, S_27_7, S_29_7, S_30_7};
        }

        function void post_randomize();
            input_coverage.sample();
        endfunction

    endclass
endpackage