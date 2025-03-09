package scoreboard_equalization;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_equalization::*;

    class scoreboard_equalization extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_equalization)
        
        int correct_count;
        int error_count;
        `uvm_analysis_imp_decl(_equalization)
        uvm_analysis_imp_equalization #(sequence_item_equalization, scoreboard_equalization) scoreboard_block;
        sequence_item_equalization equalization_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_block = new("scoreboard_block", this);
        endfunction

        virtual function void write_equalization(sequence_item_equalization packet);
            equalization_q.push_back(packet);
            //**************************//
            // TODO: Check Results Here //
            //**************************//
            // if (packet.Serial_out==packet.Serial_in)begin
            //     correct_count++;
            // end
            // else begin
            //     error_count++;
            // end
            equalization_q.push_back(packet);
            if (equalization_q.size() > 1) begin
                sequence_item_equalization old_packet = equalization_q.pop_front();
            if (packet.Serial_in != old_packet.Serial_out) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Test Failed: input = %d but output = %d ", old_packet.Serial_in, packet.Serial_out))

            end
            else begin
                correct_count++;
                `uvm_info(get_type_name(), $sformatf("Test Pass: data received = %d", packet.Serial_out), UVM_LOW);
                            end
            end
            
        endfunction 

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count=%d while error count=%d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage