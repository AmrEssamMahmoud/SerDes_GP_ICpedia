package sequence_item_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_buffer extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_buffer)

        rand bit [9:0] parallel_in;
        bit [9:0] serial_out;

        function new (string name = "sequence_item_buffer");
            super.new(name);
        endfunction : new

        //*******************************//
        // TODO: Define Constraints Here //
        //*******************************//

        //*******************************//
        // TODO: Define Covergroups Here //
        //*******************************//

    endclass
endpackage