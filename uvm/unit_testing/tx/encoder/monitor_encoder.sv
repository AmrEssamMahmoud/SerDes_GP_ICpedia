package monitor_encoder;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_encoder::*;

	class monitor_encoder extends uvm_monitor;
		`uvm_component_utils(monitor_encoder)

		virtual encoder_if  vif;
		uvm_analysis_port #(sequence_item_encoder) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual encoder_if)::get(this,"","encoder_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			@(posedge vif.Reset)
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_encoder resp = sequence_item_encoder::type_id::create("resp");        
			@(negedge vif.BitCLK_10);
			resp.input_data=vif.TxParallel_8;
			resp.output_data=vif.TxParallel_10;
			resp.TxDataK=vif.TxDataK;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass 
endpackage