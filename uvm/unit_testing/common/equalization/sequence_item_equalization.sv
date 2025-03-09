package sequence_item_equalization;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_equalization extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_equalization)

        //***************************//
        // TODO: Define Signals Here //
        //***************************//
        rand bit Serial_in;
        bit Serial_out;
        bit Reset ;

        function new (string name = "sequence_item_equalization");
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