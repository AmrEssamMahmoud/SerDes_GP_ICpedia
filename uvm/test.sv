package test;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`ifdef TOP    
		import env_top::*;
    `else
		import env_block::*;
    `endif
	`ifdef TOP
		import sequence_item_top::*;
		import sequence_top::*;
    `elsif ENCODER
		import sequence_item_encoder::*;
		import sequence_encoder::*;
    `elsif PISO
		import sequence_item_piso::*;
		import sequence_piso::*;
    `elsif SIPO
		import sequence_item_sipo::*;
		import sequence_sipo::*;
    `elsif DECODER
		import sequence_item_decoder::*;
		import sequence_decoder::*;
    `endif


	class test extends uvm_test;
		`uvm_component_utils(test)						
		
		`ifdef TOP    
			env_top env_i;
		`else
			env_block env_i;
		`endif
		`ifdef TOP    
			sequence_top sequence_i;
		`elsif ENCODER
			sequence_encoder sequence_i;
		`elsif PISO
			sequence_piso sequence_i;
		`elsif SIPO
			sequence_sipo sequence_i;
		`elsif DECODER
			sequence_decoder sequence_i;
		`endif

		function new(input string name = "test", uvm_component parent = null);
			super.new(name, parent);
		endfunction: new

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			`ifdef TOP    
				env_i = env_top::type_id::create("env_i", this);		
			`else
				env_i = env_block::type_id::create("env_i", this);		
			`endif
			`ifdef TOP    
				sequence_i = sequence_top::type_id::create("sequence_i",this);
			`elsif ENCODER
				sequence_i = sequence_encoder::type_id::create("sequence_i",this);
			`elsif PISO
				sequence_i = sequence_piso::type_id::create("sequence_i",this);
			`elsif SIPO
				sequence_i = sequence_sipo::type_id::create("sequence_i",this);
			`elsif DECODER
				sequence_i = sequence_decoder::type_id::create("sequence_i",this);
			`endif
		endfunction: build_phase

		virtual function void end_of_elaboration_phase(uvm_phase phase);
			super.end_of_elaboration_phase(phase);
			uvm_top.print_topology();	
		endfunction: end_of_elaboration_phase

		virtual task run_phase(uvm_phase phase);
				phase.raise_objection(this);
				`ifdef TOP    
					sequence_i.start(env_i.agent_top_in_i.sequencer_top_i);
				`else
					sequence_i.start(env_i.agent_block_i.sequencer_block_i);
				`endif
				phase.drop_objection(this);
		endtask: run_phase

		virtual function void report_phase(uvm_phase phase);			
			uvm_report_server svr;
			super.report_phase(phase);
			svr = uvm_report_server::get_server();

			if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin: B1
				`uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
				`uvm_info(get_type_name(), "-------------- TEST FAIL -------------", UVM_NONE)
				`uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
			end: B1		
			else begin: B2
				`uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
				`uvm_info(get_type_name(), "-------------- TEST PASS -------------", UVM_NONE)
				`uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
			end: B2

		endfunction: report_phase

	endclass
endpackage