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
            if (packet.parallel_in == packet.serial_out) begin
                `uvm_info(get_type_name(), $sformatf("Test Pass: data received = %d", packet.serial_out), UVM_LOW)
                correct_count++;
            end else begin
                `uvm_error(get_type_name(), $sformatf("Test Failed: input = %d but output = %d ", packet.parallel_in, packet.serial_out))
                error_count++;
            end        endfunction 

        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("correct_count = %0d while error count = %0d",correct_count , error_count), UVM_LOW)
        endfunction

    endclass
endpackage