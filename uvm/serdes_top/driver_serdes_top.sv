package driver_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_top ::*;
    import enums ::*;
    class driver_top extends uvm_driver #(sequence_item_top);
        `uvm_component_utils(driver_top)
    
        virtual top_if vif;
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual top_if)::get(this,"","top_if", vif))
                `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
        endfunction: connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            vif.Reset = 0;
            @(negedge vif.BitCLK_10);
            vif.Reset = 1;
            @(negedge vif.BitCLK_10);
            vif.TxDataK = 1;
            vif.TxParallel_8 = S_28_5;
            @(negedge vif.BitCLK_10);
            forever begin
                seq_item_port.get_next_item(req);
                drive_item(req);
                seq_item_port.item_done();
            end
        endtask : run_phase

        virtual task drive_item(sequence_item_top rhs);
            vif.TxDataK = rhs.tx_data_k;
            vif.TxParallel_8 = rhs.input_data;
            @(negedge vif.BitCLK_10);
        endtask : drive_item

    endclass
endpackage