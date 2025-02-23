package sequencer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `ifdef SERDES_TOP
        import sequence_item_serdes_top::*;
    `elsif ENCODER
        import sequence_item_encoder::*;
    `elsif PISO
        import sequence_item_piso::*;
    `elsif SIPO
        import sequence_item_sipo::*;
    `elsif DECODER
        import sequence_item_decoder::*;
    `elsif CDR
        import sequence_item_cdr::*;
    `endif

    class sequencer extends uvm_sequencer #(
        `ifdef SERDES_TOP
            sequence_item_serdes_top
        `elsif ENCODER
            sequence_item_encoder
        `elsif PISO
            sequence_item_piso
        `elsif SIPO
            sequence_item_sipo
        `elsif DECODER
            sequence_item_decoder
        `elsif CDR
            sequence_item_cdr
        `endif
    );
        `uvm_component_utils(sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

    endclass 
endpackage