package driver_sipo;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_sipo ::*;

    class driver_sipo extends uvm_driver #(sequence_item_sipo);
        `uvm_component_utils(driver_sipo)
    
        virtual sipo_if vif;
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual sipo_if)::get(this,"","sipo_if", vif))
                `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
        endfunction: connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            vif.Reset=0;
            @(negedge vif.BitCLK);
            vif.Reset=1;
            forever begin
                seq_item_port.get_next_item(req);
                drive_item(req);
                seq_item_port.item_done();
            end
        endtask : run_phase

        virtual task drive_item(sequence_item_sipo rhs);
            @(negedge vif.BitCLK);
            //*************************//
            // TODO: Drive Inputs Here //
            //*************************//
            // example: vif.signal = rhs.signal;
        endtask : drive_item

    endclass
endpackage