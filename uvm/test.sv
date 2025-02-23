package test;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import env::*;
	`ifdef CDR_TOP
		import sequence_item_cdr_top::*;
		import sequence_cdr_top::*;
    `elsif SERDES_TOP
		import sequence_item_serdes_top::*;
		import sequence_serdes_top::*;
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
	`elsif CDR
		import sequence_item_cdr::*;
		import sequence_cdr::*;
    `endif


	class test extends uvm_test;
		`uvm_component_utils(test)						
		
		env env_i;
		`ifdef CDR_TOP
			sequence_cdr_top sequence_i;
		`elsif SERDES_TOP
			sequence_serdes_top sequence_i;
		`elsif ENCODER
			sequence_encoder sequence_i;
		`elsif PISO
			sequence_piso sequence_i;
		`elsif SIPO
			sequence_sipo sequence_i;
		`elsif DECODER
			sequence_decoder sequence_i;
		`elsif CDR
			sequence_cdr sequence_i;
		`endif

		function new(input string name = "test", uvm_component parent = null);
			super.new(name, parent);
		endfunction: new

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env_i = env::type_id::create("env_i", this);		
			`ifdef CDR_TOP
				sequence_i = sequence_cdr_top::type_id::create("sequence_i",this);
			`elsif SERDES_TOP
				sequence_i = sequence_serdes_top::type_id::create("sequence_i",this);
			`elsif ENCODER
				sequence_i = sequence_encoder::type_id::create("sequence_i",this);
			`elsif PISO
				sequence_i = sequence_piso::type_id::create("sequence_i",this);
			`elsif SIPO
				sequence_i = sequence_sipo::type_id::create("sequence_i",this);
			`elsif DECODER
				sequence_i = sequence_decoder::type_id::create("sequence_i",this);
			`elsif CDR
				sequence_i = sequence_cdr::type_id::create("sequence_i",this);
			`endif
		endfunction: build_phase

		virtual function void end_of_elaboration_phase(uvm_phase phase);
			super.end_of_elaboration_phase(phase);
			uvm_top.print_topology();	
		endfunction: end_of_elaboration_phase

		virtual task run_phase(uvm_phase phase);
				phase.raise_objection(this);
				`ifdef CDR_TOP
					sequence_i.start(env_i.agent_cdr_top_in_i.sequencer_i);
				`elsif SERDES_TOP
					sequence_i.start(env_i.agent_serdes_top_in_i.sequencer_i);
				`else
					sequence_i.start(env_i.agent_block_i.sequencer_i);
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