package monitor_top;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_top::*;
	import enums::*;

	class monitor_top_in extends uvm_monitor;
		`uvm_component_utils(monitor_top_in)

		virtual top_if  vif;
		uvm_analysis_port #(sequence_item_top) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual top_if)::get(this,"","top_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				@(negedge vif.BitCLK_10);
				if (vif.TxParallel_8 == S_28_5)
					break;
			end
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_top resp = sequence_item_top::type_id::create("resp");            
			@(negedge vif.BitCLK_10);
			resp.input_data = vif.TxParallel_8;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass

	class monitor_top_out extends uvm_monitor;
		`uvm_component_utils(monitor_top_out)

		virtual top_if  vif;
		uvm_analysis_port #(sequence_item_top) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual top_if)::get(this,"","top_if", vif))
        	    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
          endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				@(negedge vif.BitCLK_10);
				if (vif.TxParallel_8 == S_28_5)
					break;
			end
			repeat(2) @(negedge vif.BitCLK_10);
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_top resp = sequence_item_top::type_id::create("resp");
			@(negedge vif.BitCLK_10);
			resp.output_data = vif.RxParallel_8;
			resp.rx_data_k = vif.RxDataK;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass 
endpackage