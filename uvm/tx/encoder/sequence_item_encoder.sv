package sequence_item_encoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_encoder extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_encoder)

        //***************************//
        // TODO: Define Signals Here //
        //***************************//

        function new (string name = "sequence_item_encoder");
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