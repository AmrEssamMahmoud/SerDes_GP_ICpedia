package scoreboard_encoder;
    import enums::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_encoder::*;
    import enums ::*;

    class scoreboard_encoder extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_encoder)
         
        int disparity = -1;
        int correct_count;
        int error_count;

        bit [9:0] data_encoding_table [8'h00:8'hFF][2];
        bit [9:0] control_encoding_table [8'h00:8'hFF][2];
        
        `uvm_analysis_imp_decl(_encoder)
        uvm_analysis_imp_encoder #(sequence_item_encoder, scoreboard_encoder) scoreboard_block;        

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_block = new("scoreboard_block", this);
        endfunction

        function void build_phase(uvm_phase phase);
            
            data_symbol data_symbol;
            encoded_data_p data_encoded_positive;
            encoded_data_n data_encoded_negative;

            control_symbol control_symbol;
            encoded_control_p control_encoded_positive;
            encoded_control_n control_encoded_negative;
            
            super.build_phase(phase);

            data_symbol = data_symbol.first;
            data_encoded_positive = data_encoded_positive.first;
            data_encoded_negative = data_encoded_negative.first;
            do begin
                data_encoding_table[data_symbol] = '{data_encoded_negative, data_encoded_positive};
                data_symbol = data_symbol.next;
                data_encoded_positive = data_encoded_positive.next;
                data_encoded_negative = data_encoded_negative.next;
            end while (data_symbol != data_symbol.first);

            control_symbol = control_symbol.first;
            control_encoded_positive = control_encoded_positive.first;
            control_encoded_negative = control_encoded_negative.first;
            do begin
                control_encoding_table[control_symbol] = '{control_encoded_negative, control_encoded_positive};
                control_symbol = control_symbol.next;
                control_encoded_positive = control_encoded_positive.next;
                control_encoded_negative = control_encoded_negative.next;
            end while (control_symbol != control_symbol.first);

        endfunction
    
        virtual function void write_encoder(sequence_item_encoder packet);
            bit [9:0] encoded_out;
            encode_8b10b(packet.input_data, packet.TxDataK, encoded_out);
            
            if (encoded_out != (packet.output_data)) begin
                `uvm_error("msimatch", $sformatf("expected %b output %b @ input data %s K %b ", encoded_out, packet.output_data, packet.input_data, packet.TxDataK));
                error_count++;
            end else begin
                correct_count++;
            end
    
        endfunction 

        // Task for 8b/10b encoding
        task  encode_8b10b(
            input  bit [7:0] data_in,
            input  bit data_k,
            output bit [9:0] encoded_out
        );

            int ones_count, zeros_count;
            
            // Select encoding based on current disparity
            if (data_k == 0) begin
                encoded_out = data_encoding_table[data_in][(disparity+1)/2];
            end else begin
                encoded_out = control_encoding_table[data_in][(disparity+1)/2];
            end

            // Update disparity
            ones_count = $countones(encoded_out); // Count number of 1's
            zeros_count = 10 - ones_count; // Count number of 0's
            disparity = disparity + ones_count - zeros_count;

        endtask

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d", correct_count, error_count), UVM_LOW)
        endfunction

    endclass

endpackage