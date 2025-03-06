package monitor_cdr;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_cdr::*;

	class monitor_cdr extends uvm_monitor;
		`uvm_component_utils(monitor_cdr)

		virtual cdr_if  vif;
		uvm_analysis_port #(sequence_item_cdr) item_collected_port;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction : new

        function void connect_phase(uvm_phase phase);
            if (!uvm_config_db#(virtual cdr_if)::get(this,"","cdr_if", vif))
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
			sequence_item_cdr resp = sequence_item_cdr::type_id::create("resp");            
			@(posedge vif.BitCLK);
            //***************************//
            // TODO: Sample Outputs Here //
            //***************************//
			// example: resp.signal = vif.signal
			// resp.Reset=vif.Reset;
			// resp.Dn_1=vif.Dn_1;
			// resp.Dn=vif.Dn;
			// resp.Pn=vif.Pn;
			// resp.decision1 = vif.decision1; // Sample decision signal
			resp.phase_shift=vif.phase_shift;
			resp.decision=vif.decision;
			resp.gainsel=vif.gainsel;
			item_collected_port.write(resp);
			
		endtask

	endclass 
endpackage