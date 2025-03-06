package scoreboard_sipo;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_sipo::*;

    class scoreboard_sipo extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_sipo)
        
        int correct_count;
        int error_count;

        `uvm_analysis_imp_decl(_sipo)
        uvm_analysis_imp_sipo #(sequence_item_sipo, scoreboard_sipo) scoreboard_block;
        sequence_item_sipo sipo_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_block = new("scoreboard_block", this);
        endfunction

        virtual function void write_sipo(sequence_item_sipo packet);
            if (packet.serial_in == packet.parallel_out) begin
                `uvm_info(get_type_name(), $sformatf("Test Pass: data received = %d", packet.parallel_out), UVM_LOW)
                correct_count++;
            end else begin
                `uvm_error(get_type_name(), $sformatf("Test Failed: input = %d but output = %d ", packet.serial_in, packet.parallel_out))
                error_count++;
            end
        endfunction

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d", correct_count, error_count), UVM_LOW)
        endfunction

    endclass
endpackage