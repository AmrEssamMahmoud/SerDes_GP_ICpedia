package sequence_item_piso;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import enums::*;
    
    class sequence_item_piso extends uvm_sequence_item ;
        `uvm_object_utils (sequence_item_piso)

        //***************************//
        // TODO: Define Signals Here //
        //***************************//

        function new (string name = "sequence_item_piso");
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