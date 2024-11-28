package sequence_item_sipo;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_sipo extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_sipo)

        //***************************//
        // TODO: Define Signals Here //
        //***************************//

        function new (string name = "sequence_item_sipo");
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