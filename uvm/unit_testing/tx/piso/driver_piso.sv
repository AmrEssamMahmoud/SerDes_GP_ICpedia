package driver_piso;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_piso ::*;

    class driver_piso extends uvm_driver #(sequence_item_piso);
        `uvm_component_utils(driver_piso)
    
        virtual piso_if vif;
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual piso_if)::get(this,"","piso_if", vif))
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

        virtual task drive_item(sequence_item_piso rhs);
            vif.TxParallel_10 = rhs.parallel_in;
            repeat(10) @(negedge vif.BitCLK);
        endtask : drive_item

    endclass
endpackage