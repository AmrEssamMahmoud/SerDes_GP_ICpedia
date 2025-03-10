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
        int is_first_edge = 1;
        real start_edge;
        real half_period;
        real frequency;
        real period;
        real phase;
        real ppm_rx;
        real ppm_tx;
        real ppm_difference;
        sequence_item_cdr_clock start_packet;

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
        sequence_item_cdr_clock clock_phase_q[$];
        sequence_item_cdr_clock rx_clock_ppm_q[$];

        function new(string name="", uvm_component parent = null);
            super.new(name, parent);
            scoreboard_top_in = new("scoreboard_top_in", this);
            scoreboard_top_out = new("scoreboard_top_out", this);
            scoreboard_top_cdr_tx_clock = new("scoreboard_top_cdr_tx_clock", this);
            scoreboard_top_cdr_rx_clock = new("scoreboard_top_cdr_rx_clock", this);
        endfunction

        virtual function void write_tx_clock(sequence_item_cdr_clock packet);
            ppm_tx = packet.ppm;
            calculate_phase_difference(1, packet);
        endfunction

        virtual function void write_rx_clock(sequence_item_cdr_clock packet);
            if (packet.edge_type == "posedge") begin

                if (is_first_edge) begin
                    start_packet = packet;
                    is_first_edge = 0;
                end else begin
                    rx_clock_ppm_q.push_back(packet);
                    if (rx_clock_ppm_q.size() > 300) begin
                        start_packet = rx_clock_ppm_q.pop_front();
                    end
                    frequency = rx_clock_ppm_q.size() * 100000 / (packet.time_sample - start_packet.time_sample);
                    ppm_rx = (frequency - 5) * 1e6 / 5;

                    if ($realtime > 30000000) begin
                        ppm_difference = (ppm_rx < ppm_tx) ? (ppm_tx - ppm_rx) : (ppm_rx - ppm_tx);
                        if (ppm_difference > 15) begin
                            `uvm_error(get_type_name(), $sformatf("Large ppm offset error: ppm_rx = %0f, ppm_tx = %0f", ppm_rx, ppm_tx))
                            error_count ++;
                        end
                    end
                end

            end

            if (packet.edge_type == "posedge") begin
                period = packet.time_sample - start_edge;
                if (start_edge != 0) begin
                    if (0.49 > (half_period / period) || (half_period / period) > 0.51) begin
                        `uvm_error(get_type_name(), $sformatf("Pulse width error: the period width is %0f but the high pulse width is %0f", period, half_period))
                        error_count ++;
                    end
                end
                start_edge = packet.time_sample;
            end else begin
                half_period =  packet.time_sample - start_edge;
            end
            
            if (packet.edge_type == "negedge") begin
                calculate_phase_difference(-1, packet);
            end
        endfunction


        task calculate_phase_difference (
            input int sign,
            input sequence_item_cdr_clock current_packet
        );

            if (clock_phase_q.size() > 0) begin
                sequence_item_cdr_clock previous_packet = clock_phase_q.pop_front();
                phase = 360 * sign * (current_packet.time_sample - previous_packet.time_sample) / 20000;
                if ($realtime > 30000000) begin
                    if (phase < -5 || 5 < phase) begin
                        `uvm_error(get_type_name(), $sformatf("Phase lock error: phase differece = %0f", phase))
                        error_count ++;
                    end
                end
            end else begin
                clock_phase_q.push_back(current_packet);
            end

        endtask

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