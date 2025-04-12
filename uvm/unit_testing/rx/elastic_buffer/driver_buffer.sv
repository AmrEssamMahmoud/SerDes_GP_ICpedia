package driver_buffer;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sequence_item_buffer ::*;

    class driver_buffer extends uvm_driver #(sequence_item_buffer);
        `uvm_component_utils(driver_buffer)
    
        virtual buffer_if vif;
    
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual buffer_if)::get(this,"","buffer_if", vif))
                `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
        endfunction: connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            vif.rrst_n=0;
            vif.lrst_n=0;
            @(negedge vif.rclk);
            vif.rrst_n=1;
            vif.lrst_n=1;
            vif.data_in_vld=1;
            forever begin
                seq_item_port.get_next_item(req);
                drive_item(req);
                seq_item_port.item_done();
            end
        endtask : run_phase

        virtual task drive_item(sequence_item_buffer rhs);
            @(negedge vif.rclk);
            vif.data_in = rhs.data_in;
        endtask : drive_item

    endclass
endpackage