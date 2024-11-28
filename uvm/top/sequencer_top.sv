package sequencer_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_top::*;

    class sequencer_top extends uvm_sequencer #(sequence_item_top);
        `uvm_component_utils(sequencer_top)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

    endclass 
endpackage