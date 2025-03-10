package sequence_item_decoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_decoder extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_decoder)
        
        static int disparity = -1;

        rand encoded_data_p data_positive;
        rand encoded_data_n data_negative;
        rand encoded_control_p control_positive;
        rand encoded_control_n control_negative;
        rand bit data_k;
        bit[7:0] RxParallel_8;
        bit[9:0] RxParallel_10;
        bit RxDataK;

        constraint data_k_const {
            data_k dist {1:=10, 0:=90};
        }

        function void  post_randomize ();
            int ones, zeros;

            bit [9:0] randomized_options [2][2] = '{
                '{data_negative, data_positive},
                '{control_negative, control_positive}
            };

            RxParallel_10 = randomized_options[data_k][(disparity+1)/2];

            ones = $countones(RxParallel_10);
            zeros = 10 - ones;
            disparity = disparity + ones - zeros;
        endfunction
        
        function new (string name = "sequence_item_decoder");
            super.new(name);
        endfunction : new

    endclass
endpackage