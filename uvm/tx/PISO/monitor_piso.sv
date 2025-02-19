package monitor_piso;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_piso::*;

	class monitor_piso extends uvm_monitor;
		`uvm_component_utils(monitor_piso)

		virtual piso_if  vif;
		uvm_analysis_port #(sequence_item_piso) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual piso_if)::get(this,"","piso_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			@(posedge vif.Reset)
			@(negedge vif.BitCLK)
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_piso resp = sequence_item_piso::type_id::create("resp");            
			bit [9:0] serial_out;
			resp.parallel_in = vif.TxParallel_10;
			for (int i = 0; i < 10; i++) begin
				serial_out = {vif.Serial, serial_out[9:1]};
				@(negedge vif.BitCLK);
			end
			resp.serial_out = serial_out;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass 
endpackage