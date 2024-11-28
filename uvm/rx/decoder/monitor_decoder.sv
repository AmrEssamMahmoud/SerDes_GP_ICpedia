package monitor_decoder;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_decoder::*;

	class monitor_decoder extends uvm_monitor;
		`uvm_component_utils(monitor_decoder)

		virtual decoder_if  vif;
		uvm_analysis_port #(sequence_item_decoder) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual decoder_if)::get(this,"","decoder_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_decoder resp = sequence_item_decoder::type_id::create("resp");            
			@(posedge vif.BitCLK_10);
            //***************************//
            // TODO: Sample Outputs Here //
            //***************************//
			// example: resp.signal = vif.signal
			item_collected_port.write(resp);
		endtask : sample_item

	endclass 
endpackage