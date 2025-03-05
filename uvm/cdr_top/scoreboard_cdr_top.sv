package scoreboard_cdr_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_cdr_top::*;

    class scoreboard_cdr_top extends uvm_scoreboard;
        `uvm_component_utils(scoreboard_cdr_top)
        
        int correct_count;
        int error_count;
        int enc_packets;
        int dec_packets;
        int cycles_count = 0;
        real start_time;
        real phase;
        real frequency;
        real ppm;

        `uvm_analysis_imp_decl(_enc)
        `uvm_analysis_imp_decl(_dec)
        `uvm_analysis_imp_decl(_tx_clock)
        `uvm_analysis_imp_decl(_rx_clock)
        
        uvm_analysis_imp_enc #(sequence_item_cdr_top, scoreboard_cdr_top) scoreboard_top_in;
        uvm_analysis_imp_dec #(sequence_item_cdr_top, scoreboard_cdr_top) scoreboard_top_out;
        uvm_analysis_imp_tx_clock #(sequence_item_cdr_clock, scoreboard_cdr_top) scoreboard_top_cdr_tx_clock;
        uvm_analysis_imp_rx_clock #(sequence_item_cdr_clock, scoreboard_cdr_top) scoreboard_top_cdr_rx_clock;
        
        sequence_item_cdr_top enc_q[$];
        sequence_item_cdr_top dec_q[$];
        sequence_item_cdr_clock tx_clock_q[$];
        sequence_item_cdr_clock rx_clock_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_top_in = new("scoreboard_top_in", this);
            scoreboard_top_out = new("scoreboard_top_out", this);
            scoreboard_top_cdr_tx_clock = new("scoreboard_top_cdr_tx_clock", this);
            scoreboard_top_cdr_rx_clock = new("scoreboard_top_cdr_rx_clock", this);
        endfunction

        virtual function void write_tx_clock(sequence_item_cdr_clock packet);
            if (rx_clock_q.size() > 0) begin
                sequence_item_cdr_clock rx_packet = rx_clock_q.pop_front();
                // `uvm_info(get_type_name(), $sformatf("tx sample = %0d | rx sample = %0d | phase = %0d", packet.time_sample, rx_packet.time_sample, phase), UVM_LOW)
                phase = 360 * (packet.time_sample - rx_packet.time_sample) / 20000;
            end else begin
                tx_clock_q.push_back(packet);
            end
        endfunction

        virtual function void write_rx_clock(sequence_item_cdr_clock packet);
            if (cycles_count == 0) begin
                start_time = packet.time_sample;
            end else begin
                frequency = cycles_count * 100000 / (packet.time_sample - start_time);
                ppm = (frequency - 5) * 1e6 / 5;
            end
            cycles_count = cycles_count + 1;

            if (tx_clock_q.size() > 0) begin
                sequence_item_cdr_clock tx_packet = tx_clock_q.pop_front();
                // `uvm_info(get_type_name(), $sformatf("tx sample = %0d | rx sample = %0d | phase = %0d", tx_packet.time_sample, packet.time_sample, phase), UVM_LOW)
                phase = 360 * (tx_packet.time_sample - packet.time_sample) / 20000;
            end else begin
                rx_clock_q.push_back(packet);
            end
        endfunction 

        virtual function void write_enc(sequence_item_cdr_top packet);
            enc_q.push_back(packet);
            enc_packets++;
        endfunction 
        
        virtual function void write_dec(sequence_item_cdr_top packet);
            sequence_item_cdr_top enc_packet = enc_q.pop_front();
            if (packet.output_data == enc_packet.input_data) begin
                // `uvm_info(get_type_name(), $sformatf("test_passed_data = %d", enc_packet.input_data.name), UVM_LOW)
                correct_count ++;
            end 
            else begin
                `uvm_error(get_type_name(), $sformatf("test_failed_input_data = %d but output data = %d ",enc_packet.input_data.name ,packet.output_data.name))
                error_count ++;
            end
            dec_packets++;
        endfunction

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage