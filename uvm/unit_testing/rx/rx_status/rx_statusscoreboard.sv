import uvm_pkg::*;
`include "uvm_macros.svh"
class rx_statusscoreboard extends uvm_scoreboard;
    `uvm_component_utils(rx_statusscoreboard)

    bit [9:0] COM_SYM = 10'h1BC;
    bit [9:0] SKP_SYM = 10'h1A1;

    int correct_count;
    int error_count;

    uvm_analysis_imp_decl(_rx_status_in)
    uvm_analysis_imp_decl(_rx_status_out)

    uvm_analysis_imp_rx_status_in #(rx_status, rx_statusscoreboard) rx_status_in;
    uvm_analysis_imp_rx_status_out #(rx_status, rx_statusscoreboard) rx_status_out;

    rx_status rx_input_q[$];
    rx_status rx_output_q[$];

    function new(string name="", uvm_component parent = null);
        super.new(name, parent);
        rx_status_in = new("rx_status_in", this);
        rx_status_out = new("rx_status_out", this);
    endfunction

    virtual function void write_rx_status_in(rx_status packet);
        if (packet.data_in != SKP_SYM) begin
            rx_input_q.push_back(packet);
        end
    endfunction

    virtual function void write_rx_status_out(rx_status packet);
        if (rx_input_q.size() > 0 && packet.data_out != SKP_SYM) begin
            rx_status input_packet = rx_input_q.pop_front();
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