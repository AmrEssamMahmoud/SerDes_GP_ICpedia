package monitor_sipo;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_sipo::*;
    import enums::*;

	class monitor_sipo extends uvm_monitor;
		`uvm_component_utils(monitor_sipo)

		virtual sipo_if  vif;
		uvm_analysis_port #(sequence_item_sipo) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual sipo_if)::get(this,"","sipo_if", vif))
	            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
		endfunction: connect_phase

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			item_collected_port = new("item_collected_port", this);
		endfunction : build_phase

		virtual task run_phase(uvm_phase phase);
			bit [11:0] serial_in = 0;
			bit last_comma = 0;
			super.run_phase(phase);
			@(posedge vif.Reset);
			forever begin
				detect_comma(last_comma);
				if (last_comma)
					break;
			end
			repeat (2) begin
				@(posedge vif.BitCLK);
				serial_in = {vif.Serial, serial_in[11:1]};
			end
			forever begin
				for (int i = 0; i < 10; i++) begin
					@(posedge vif.BitCLK);
					serial_in = {vif.Serial, serial_in[11:1]};
				end
				sample_item(serial_in[9:0]);
			end
		endtask : run_phase

		virtual task sample_item(bit [9:0] serial_in);
			sequence_item_sipo resp = sequence_item_sipo::type_id::create("resp");
			resp.serial_in = serial_in;
            resp.parallel_out = vif.RxParallel_10;
			item_collected_port.write(resp);
		endtask : sample_item

		task detect_comma(output bit last_comma);
			logic [9:0] last_10_bits = 10'bX;
			forever begin
				@(posedge vif.BitCLK);
				last_10_bits = {vif.Serial, last_10_bits[9:1]};
				if (last_10_bits == K_28_1_p || last_10_bits == K_28_1_n || last_10_bits == K_28_5_p || last_10_bits == K_28_5_n || last_10_bits == K_28_7_n) begin
					break;
				end else if (last_10_bits == K_28_7_p) begin
					last_comma = 1;
					break;
				end
			end
			`uvm_info(get_type_name(), $sformatf("Comma Detected."), UVM_LOW)
		endtask : detect_comma

	endclass 
endpackage