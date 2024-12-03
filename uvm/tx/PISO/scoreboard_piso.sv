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
            // TODO: Check Results Here ///**/
            bit [9:0] expected_serial;
            bit [9:0] actual_serial;

            function new(string name = "uvm_piso_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            endfunction

            // Check if the output matches the expected value
             virtual function void write(input bit serial);
            // Compare the expected and actual serial data
            actual_serial = serial;
            if (actual_serial !== expected_serial) begin
            `uvm_error("SERIAL_MISMATCH", "Mismatch between expected and actual serial data.")
            end
            endfunction
            //**************************//
        endfunction 

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count=%d while error count=%d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage