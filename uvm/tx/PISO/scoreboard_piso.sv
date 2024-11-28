package scoreboard_piso;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_piso::*;

    class scoreboard_piso extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_piso)
        
        int correct_count;
        int error_count;
        `uvm_analysis_imp_decl(_piso)
        uvm_analysis_imp_piso #(sequence_item_piso, scoreboard_piso) scoreboard_block;
        sequence_item_piso piso_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_block = new("scoreboard_block", this);
        endfunction

        virtual function void write_piso(sequence_item_piso packet);
            piso_q.push_back(packet);
            //**************************//
            // TODO: Check Results Here //
            //**************************//
        endfunction 

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count=%d while error count=%d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage