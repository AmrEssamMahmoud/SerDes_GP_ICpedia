package sequence_item_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_buffer extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_buffer)

        randc int random_unique;
        bit [9:0] data_in;
        bit [9:0] data_out;
        constraint not_comma_nor_skp {soft data_in !=  10'h1BC;
        soft data_in !=  10'h1A1;}
        

        function new (string name = "sequence_item_buffer");
            super.new(name);
        endfunction : new
        
        function void  post_randomize ();
            data_in = random_unique;
        endfunction
        
        //*******************************//
        // TODO: Define Covergroups Here //
        //*******************************//

    endclass
endpackage