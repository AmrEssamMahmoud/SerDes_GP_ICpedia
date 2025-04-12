package scoreboard_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_buffer::*;

    class scoreboard_buffer extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_buffer)

        bit [9:0] SKP_SYM1 = 10'h0f9; // First SKP symbol (COM)
        bit [9:0] SKP_SYM2 = 10'h306; // Second SKP symbol (SKP)

        int correct_count;
        int error_count;

        `uvm_analysis_imp_decl(_buffer_in)
        `uvm_analysis_imp_decl(_buffer_out)

        uvm_analysis_imp_buffer_in #(sequence_item_buffer, scoreboard_buffer) scoreboard_buffer_in;
        uvm_analysis_imp_buffer_out #(sequence_item_buffer, scoreboard_buffer) scoreboard_buffer_out;

        sequence_item_buffer buffer_input_q[$];
        sequence_item_buffer buffer_output_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_buffer_in = new("scoreboard_buffer_in", this);
            scoreboard_buffer_out = new("scoreboard_buffer_out", this);
        endfunction

        virtual function void write_buffer_in(sequence_item_buffer packet);
            if (packet.data_in != SKP_SYM1 && packet.data_in != SKP_SYM2) begin
                buffer_input_q.push_back(packet);
            end
        endfunction

        virtual function void write_buffer_out(sequence_item_buffer packet);
            if (buffer_input_q.size() > 0 && packet.data_out != SKP_SYM1 && packet.data_out != SKP_SYM2) begin
                sequence_item_buffer input_packet = buffer_input_q.pop_front();
                // `uvm_info(get_type_name(), $sformatf("input_data = %0d while output_data = %0d",input_packet.data_in , packet.data_out), UVM_LOW)
                if (input_packet.data_in != packet.data_out) begin
                    `uvm_error(get_type_name(), $sformatf("test_failed_input_data = %h but output data = %h ", input_packet.data_in , packet.data_out))
                    error_count ++;
                end else begin
                    correct_count ++;
                end
            end
        endfunction

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage