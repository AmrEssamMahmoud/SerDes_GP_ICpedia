package coverage_encoder ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item_encoder::*;

	class coverage_encoder extends uvm_component;
		`uvm_component_utils(coverage_encoder)

		uvm_analysis_export 	#(sequence_item_encoder) cov_export_in;
		uvm_tlm_analysis_fifo 	#(sequence_item_encoder) cov_fifo_in;

		

        sequence_item_encoder cov_item_in;
	
		covergroup cg;
			symbols: 		coverpoint cov_item_in.input_data;
		endgroup

		function new(string name, uvm_component parent);
			super.new(name, parent);
			cg = new();
		endfunction : new

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export_in 	= new("cov_export_in", this); 		// Connected to agent analysis post (mon >> agt >> cov)
			cov_fifo_in 	= new("cov_fifo_in", this);			// Connected to cov_export (cov_export >> fifo.export)
		endfunction : build_phase

		virtual function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export_in.connect(cov_fifo_in.analysis_export);
		endfunction : connect_phase


		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin

				cov_fifo_in.get(cov_item_in);
				
				cg.sample();
			end
		endtask : run_phase

	endclass 
endpackage