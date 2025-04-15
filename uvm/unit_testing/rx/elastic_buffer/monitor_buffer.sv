package monitor_buffer;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_buffer::*;

	class monitor_buffer_in extends uvm_monitor;
		`uvm_component_utils(monitor_buffer_in)

		virtual buffer_if vif;
		uvm_analysis_port #(sequence_item_buffer) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual buffer_if)::get(this,"","buffer_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			@(posedge vif.rrst_n)
			@(negedge vif.rclk)
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_buffer resp = sequence_item_buffer::type_id::create("resp");
			@(negedge vif.rclk);
			resp.data_in = vif.data_in;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass

	class monitor_buffer_out extends uvm_monitor;
		`uvm_component_utils(monitor_buffer_out)

		virtual buffer_if vif;
		uvm_analysis_port #(sequence_item_buffer) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual buffer_if)::get(this,"","buffer_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			@(posedge vif.lrst_n)
			@(posedge vif.data_out_vld)
			repeat(2) @(negedge vif.lclk);
			forever begin
				sample_item();
			end
		endtask : run_phase

		virtual task sample_item();
			sequence_item_buffer resp = sequence_item_buffer::type_id::create("resp");
			@(negedge vif.lclk);
			resp.data_out = vif.data_out;
			item_collected_port.write(resp);
		endtask : sample_item

	endclass

endpackage