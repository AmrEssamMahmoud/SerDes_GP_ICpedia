package scoreboard_encoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_encoder::*;

    class scoreboard_encoder extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_encoder)
        
        int correct_count;
        int error_count;
        `uvm_analysis_imp_decl(_encoder)
        uvm_analysis_imp_encoder #(sequence_item_encoder, scoreboard_encoder) scoreboard_block;
        sequence_item_encoder encoder_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_block = new("scoreboard_block", this);
        endfunction

        virtual function void write_encoder(sequence_item_encoder packet);
            encoder_q.push_back(packet);
            //**************************//
            // TODO: Check Results Here //
            //**************************//
        endfunction 

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count=%d while error count=%d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage