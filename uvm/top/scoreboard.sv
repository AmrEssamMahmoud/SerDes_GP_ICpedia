package scoreboard;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_top::*;

    class scoreboard extends uvm_scoreboard;
        `uvm_component_utils(scoreboard)
        
        int correct_count;
        int error_count;
        int enc_packets;
        int dec_packets;

        `uvm_analysis_imp_decl(_enc)
        `uvm_analysis_imp_decl(_dec)
        
        uvm_analysis_imp_enc #(sequence_item_top, scoreboard) scoreboard_top_in;
        uvm_analysis_imp_dec #(sequence_item_top, scoreboard) scoreboard_top_out;
        
        sequence_item_top enc_q[$];
        sequence_item_top dec_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_top_in = new("scoreboard_top_in", this);
            scoreboard_top_out = new("scoreboard_top_out", this);
        endfunction

        virtual function void write_enc(sequence_item_top packet);
            enc_q.push_back(packet);
            enc_packets++;
        endfunction 
        
        virtual function void write_dec(sequence_item_top packet);
            sequence_item_top enc_packet = enc_q.pop_front();
            if (packet.output_data == enc_packet.input_data) begin
                `uvm_info(get_type_name(), $sformatf("test_passed_data =%d ",enc_packet.input_data ), UVM_LOW)
                correct_count ++;
            end 
            else begin
                `uvm_error(get_type_name(), $sformatf("test_failed_input_data =%d but output data=%d ",enc_packet.input_data.name ,packet.output_data.name))
                error_count ++;
            end
            dec_packets++;
        endfunction

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count=%d while error count=%d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage