package scoreboard_decoder;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_decoder::*;
    import enums ::*;

    class scoreboard_decoder extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_decoder)
        
        int correct_count;
        int error_count;

        bit [7:0] data_decoding_table [10'h000:10'h3FF];
        bit [7:0] control_decoding_table [10'h000:10'h3FF];
        
        `uvm_analysis_imp_decl(_decoder)
        uvm_analysis_imp_decoder #(sequence_item_decoder, scoreboard_decoder) scoreboard_block;

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
                data_decoding_table[data_encoded_positive] = data_symbol;
                data_decoding_table[data_encoded_negative] = data_symbol;
                data_symbol = data_symbol.next;
                data_encoded_positive = data_encoded_positive.next;
                data_encoded_negative = data_encoded_negative.next;
            end while (data_symbol != data_symbol.first);

            control_symbol = control_symbol.first;
            control_encoded_positive = control_encoded_positive.first;
            control_encoded_negative = control_encoded_negative.first;
            do begin
                control_decoding_table[control_encoded_positive] = control_symbol;
                control_decoding_table[control_encoded_negative] = control_symbol;
                control_symbol = control_symbol.next;
                control_encoded_positive = control_encoded_positive.next;
                control_encoded_negative = control_encoded_negative.next;
            end while (control_symbol != control_symbol.first);

        endfunction

        function void write_decoder(sequence_item_decoder packet);
            
            bit RxDataK;
            bit [7:0] decoded_data;
            decode(packet.RxParallel_10,decoded_data,RxDataK);
        
            if (decoded_data != packet.RxParallel_8 || RxDataK !=packet.RxDataK) begin
                `uvm_error("mismatch", $sformatf("expected %b k %b output %b k %b @ input data %b  ", decoded_data,RxDataK,packet.RxParallel_8 ,packet.RxDataK ,packet.RxParallel_10 ));
                error_count++;
            end else begin
                correct_count++;
            end
        endfunction 
        
        task decode(
            input  bit [9:0] data_in,
            output bit [7:0] decoded_data,
            output bit RxDataK
        );

            bit k_28_x;
            bit k_x_7;
            bit d_x_A7;
           
            k_28_x = data_in[5:0] == K_28_x_p || data_in[5:0]== K_28_x_n;
            k_x_7 = data_in[9:6] == K_x_7_p || data_in[9:6] == K_x_7_n;
            d_x_A7 = data_in[5:0] == E_11_x_p || data_in[5:0] == E_13_x_p || data_in[5:0] == E_14_x_p || data_in[5:0] == E_17_x_n || data_in[5:0] == E_18_x_n || data_in[5:0] == E_20_x_n;

            if (k_28_x || (k_x_7 && !d_x_A7)) begin // K.28.x or ( K.x.7 and not D.x.A7) 
                decoded_data = control_decoding_table[data_in];
                RxDataK = 1;
            end else begin
                decoded_data = data_decoding_table[data_in];
                RxDataK = 0;
            end

        endtask
        
        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d", correct_count, error_count), UVM_LOW)
        endfunction

    endclass
endpackage
 